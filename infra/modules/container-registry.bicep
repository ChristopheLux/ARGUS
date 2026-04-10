// Container Registry - Basic SKU, managed identity pull, private-only by default
param location string
param containerRegistryName string
param tags object
param privateEndpointsSubnetId string = ''

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: containerRegistryName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
    publicNetworkAccess: 'Disabled'
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

output registryId string = containerRegistry.id
output registryName string = containerRegistry.name
output registryLoginServer string = containerRegistry.properties.loginServer
