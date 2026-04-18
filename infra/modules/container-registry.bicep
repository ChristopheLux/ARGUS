// Container Registry - Basic SKU, managed identity pull, private-only by default
param location string
param containerRegistryName string
param tags object
param privateEndpointsSubnetId string = ''
param privateDnsZoneAcrId string = ''

@description('Optional public IP allowed to access ACR (dev only). Leave empty to disable.')
param allowedDevIp string = '82.64.62.124'

var allowDevIp = !empty(allowedDevIp)


resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: containerRegistryName
  location: location
  sku: {
    name: 'Premium'
  }
  properties: {
    adminUserEnabled: false
    //publicNetworkAccess: 'Disabled'
    
publicNetworkAccess: 'Enabled'
    networkRuleSet: {
      defaultAction: 'Deny'
    }
    networkRuleBypassOptions: 'AzureServices' // Authorize trusted Azure Services
  }
  tags: tags
  }



// Private Endpoint for ACR (deployed only when a private endpoints subnet is provided)
resource acrPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = if (privateEndpointsSubnetId != '') {
  name: 'pe-acr-${uniqueString(containerRegistry.id)}'
  location: location
  properties: {
    subnet: { id: privateEndpointsSubnetId }
    privateLinkServiceConnections: [
      {
        name: 'acr-connection'
        properties: {
          privateLinkServiceId: containerRegistry.id
          groupIds: [
            'registry'
          ]
        }
      }
    ]
  }
}

// DNS group for ACR private endpoint (integrates with private DNS zone)
resource acrDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = if (privateDnsZoneAcrId != '') {
  parent: acrPrivateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config'
        properties: {
          privateDnsZoneId: privateDnsZoneAcrId
        }
      }
    ]
  }
}

output registryId string = containerRegistry.id
output registryName string = containerRegistry.name
output registryLoginServer string = containerRegistry.properties.loginServer
