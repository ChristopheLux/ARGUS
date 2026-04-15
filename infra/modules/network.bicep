// Virtual Network with subnets for all services
param location string
param resourceToken string
param tags object
param vnetAddressSpace string = '10.0.0.0/16'
param containerAppsSubnetAddressPrefix string = '10.0.0.0/21'
param privateEndpointsSubnetAddressPrefix string = '10.0.8.0/24'

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
          addressPrefix: containerAppsSubnetAddressPrefix
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
          addressPrefix: privateEndpointsSubnetAddressPrefix
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

resource privateDnsZoneAcr 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.azurecr.io'
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

resource vnetLinkAcr 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneAcr
  name: 'link-acr'
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

output vnetId string = vnet.id
output vnetName string = vnet.name
output containerAppsSubnetId string = vnet.properties.subnets[0].id
output privateEndpointsSubnetId string = vnet.properties.subnets[1].id
output privateDnsZoneBlobId string = privateDnsZoneBlob.id
output privateDnsZoneCosmosId string = privateDnsZoneCosmos.id
output privateDnsZoneCognitiveServicesId string = privateDnsZoneCognitiveServices.id
output privateDnsZoneOpenAIId string = privateDnsZoneOpenAI.id
output privateDnsZoneKeyVaultId string = privateDnsZoneKeyVault.id
output privateDnsZoneAcrId string = privateDnsZoneAcr.id
output privateDnsZoneLogAnalyticsId string = privateDnsZoneLogAnalytics.id
output privateDnsZoneAppInsightsId string = privateDnsZoneAppInsights.id
output privateDnsZoneMonitorId string = privateDnsZoneMonitor.id
output privateDnsZoneOmsId string = privateDnsZoneOms.id
