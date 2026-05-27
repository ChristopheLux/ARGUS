// Virtual Network with subnets for all services
// Private DNS zones for all PaaS services that use private endpoints.
// ACR is intentionally public — no ACR DNS zone needed.
//
// Subnet layout is derived from vnetAddressSpace using cidrSubnet() — sizes scale
// with the VNet so a larger VNet gets larger subnets instead of wasting addresses.
//
//   Container Apps env: /27 minimum (ACA Workload Profiles floor), grows to roughly
//                       half the VNet on /22+ inputs (vnetPrefix + 3, capped at /27).
//   Private endpoints:  fixed /27 — 32 IPs handles every PE in this template.
//   App Gateway:        fixed /26 — AGW v2 + WAF minimum, always created (only
//                       attached when deployAppGateway = true).
//
// Default /24 (256 addresses) carves to .0/27, .32/27, .64/26 — unchanged from before.
// A /22 (1024 addresses) carves to .0/25 (CA), .128/27 (PE), .192/26 (AGW).
// A /20 (4096 addresses) carves to .0/23 (CA), .2.0/27 (PE), .2.64/26 (AGW).
//
// Note: Consumption-only ACA environments require /23 minimum for the infrastructure
// subnet. main.bicep deploys the ACA env with Workload Profiles, so the floor is /27.
param location string
param resourceToken string
param tags object

@description('VNet address space in CIDR notation. Subnets are derived from this — passed in from main.bicep as the single source of truth.')
param vnetAddressSpace string

// Derive prefix lengths from the VNet size so a /22 or /20 input grows the CA subnet
// instead of leaving address space stranded.
var vnetPrefix = int(split(vnetAddressSpace, '/')[1])
var caPrefix = min(vnetPrefix + 3, 27) // floor at /27 (ACA Workload Profiles minimum)
var pePrefix = 27
var agwPrefix = 26

// Bicep has no pow() — enumerate 2^(27 - caPrefix) so we know how many /27 slots
// the CA subnet consumes. Used to place PE and AGW right after it without overlap.
var caSlotsOf27 = caPrefix == 27 ? 1 : caPrefix == 26 ? 2 : caPrefix == 25 ? 4 : caPrefix == 24 ? 8 : caPrefix == 23 ? 16 : caPrefix == 22 ? 32 : caPrefix == 21 ? 64 : caPrefix == 20 ? 128 : 256
var peIndex = caSlotsOf27
// AGW is /26 (= 2 /27 slots); align it to the next /26 boundary past PE.
// ceil((caSlotsOf27 + 1) / 2) using integer math.
var agwIndex = (caSlotsOf27 + 2) / 2

var containerAppsSubnetPrefix = cidrSubnet(vnetAddressSpace, caPrefix, 0)
var privateEndpointsSubnetPrefix = cidrSubnet(vnetAddressSpace, pePrefix, peIndex)
var appGatewaySubnetPrefix = cidrSubnet(vnetAddressSpace, agwPrefix, agwIndex)

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet-${resourceToken}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [vnetAddressSpace]
    }
    subnets: [
      {
        name: 'snet-container-apps'
        properties: {
          addressPrefix: containerAppsSubnetPrefix
          delegations: [
            {
              name: 'Microsoft.App.environments'
              properties: {
                serviceName: 'Microsoft.App/environments'
              }
            }
          ]
        }
      }
      {
        name: 'snet-private-endpoints'
        properties: {
          addressPrefix: privateEndpointsSubnetPrefix
        }
      }
      {
        name: 'snet-app-gateway'
        properties: {
          addressPrefix: appGatewaySubnetPrefix
        }
      }
    ]
  }
  tags: tags
}

resource privateDnsZoneBlob 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.blob.${environment().suffixes.storage}'
  location: 'global'
  tags: tags
}

resource privateDnsZoneCosmos 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.documents.azure.com'
  location: 'global'
  tags: tags
}

resource privateDnsZoneCognitiveServices 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.cognitiveservices.azure.com'
  location: 'global'
  tags: tags
}

resource privateDnsZoneOpenAI 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.openai.azure.com'
  location: 'global'
  tags: tags
}

resource privateDnsZoneKeyVault 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.vaultcore.azure.net'
  location: 'global'
  tags: tags
}

resource privateDnsZoneLogAnalytics 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.ods.opinsights.azure.com'
  location: 'global'
  tags: tags
}

resource privateDnsZoneAppInsights 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.dc.applicationinsights.azure.com'
  location: 'global'
  tags: tags
}

resource privateDnsZoneMonitor 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.monitor.azure.com'
  location: 'global'
  tags: tags
}

resource privateDnsZoneOms 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.oms.opinsights.azure.com'
  location: 'global'
  tags: tags
}

resource privateDnsZoneAgentSvc 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.agentsvc.azure-automation.net'
  location: 'global'
  tags: tags
}

// VNet links for all private DNS zones
resource vnetLinkBlob 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneBlob
  name: 'link-blob'
  location: 'global'
  properties: {
    virtualNetwork: { id: vnet.id }
    registrationEnabled: false
  }
}

resource vnetLinkCosmos 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneCosmos
  name: 'link-cosmos'
  location: 'global'
  properties: {
    virtualNetwork: { id: vnet.id }
    registrationEnabled: false
  }
}

resource vnetLinkCognitiveServices 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneCognitiveServices
  name: 'link-cognitive'
  location: 'global'
  properties: {
    virtualNetwork: { id: vnet.id }
    registrationEnabled: false
  }
}

resource vnetLinkOpenAI 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneOpenAI
  name: 'link-openai'
  location: 'global'
  properties: {
    virtualNetwork: { id: vnet.id }
    registrationEnabled: false
  }
}

resource vnetLinkKeyVault 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneKeyVault
  name: 'link-keyvault'
  location: 'global'
  properties: {
    virtualNetwork: { id: vnet.id }
    registrationEnabled: false
  }
}

resource vnetLinkLogAnalytics 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneLogAnalytics
  name: 'link-loganalytics'
  location: 'global'
  properties: {
    virtualNetwork: { id: vnet.id }
    registrationEnabled: false
  }
}

resource vnetLinkAppInsights 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneAppInsights
  name: 'link-appinsights'
  location: 'global'
  properties: {
    virtualNetwork: { id: vnet.id }
    registrationEnabled: false
  }
}

resource vnetLinkMonitor 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneMonitor
  name: 'link-monitor'
  location: 'global'
  properties: {
    virtualNetwork: { id: vnet.id }
    registrationEnabled: false
  }
}

resource vnetLinkOms 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneOms
  name: 'link-oms'
  location: 'global'
  properties: {
    virtualNetwork: { id: vnet.id }
    registrationEnabled: false
  }
}

resource vnetLinkAgentSvc 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneAgentSvc
  name: 'link-agentsvc'
  location: 'global'
  properties: {
    virtualNetwork: { id: vnet.id }
    registrationEnabled: false
  }
}

output vnetId string = vnet.id
output vnetName string = vnet.name
output containerAppsSubnetId string = vnet.properties.subnets[0].id
output privateEndpointsSubnetId string = vnet.properties.subnets[1].id
output appGatewaySubnetId string = vnet.properties.subnets[2].id
output privateDnsZoneBlobId string = privateDnsZoneBlob.id
output privateDnsZoneCosmosId string = privateDnsZoneCosmos.id
output privateDnsZoneCognitiveServicesId string = privateDnsZoneCognitiveServices.id
output privateDnsZoneOpenAIId string = privateDnsZoneOpenAI.id
output privateDnsZoneKeyVaultId string = privateDnsZoneKeyVault.id
output privateDnsZoneLogAnalyticsId string = privateDnsZoneLogAnalytics.id
output privateDnsZoneAppInsightsId string = privateDnsZoneAppInsights.id
output privateDnsZoneMonitorId string = privateDnsZoneMonitor.id
output privateDnsZoneOmsId string = privateDnsZoneOms.id
output privateDnsZoneAgentSvcId string = privateDnsZoneAgentSvc.id
