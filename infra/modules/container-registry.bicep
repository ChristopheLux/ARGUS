// Container Registry - Premium SKU, managed identity pull, PUBLIC access (per design)
// ACR is intentionally the only component left publicly accessible so that azd / CI pipelines
// can push images without VNet integration. All other services are private.
param location string
param containerRegistryName string
param tags object

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: containerRegistryName
  location: location
  sku: {
    name: 'Premium'
  }
  properties: {
    adminUserEnabled: false
    publicNetworkAccess: 'Enabled'
    networkRuleSet: {
      defaultAction: 'Allow'
    }
    networkRuleBypassOptions: 'AzureServices'
  }
  tags: tags
}

output registryId string = containerRegistry.id
output registryName string = containerRegistry.name
output registryLoginServer string = containerRegistry.properties.loginServer
