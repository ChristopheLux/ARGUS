// Azure AI Services (OpenAI) with private endpoint and managed identity auth
param location string
param resourceToken string
param tags object
param azureOpenaiModelDeploymentName string
param azureOpenaiModelName string
param azureOpenaiModelVersion string = ''
param azureOpenaiModelCapacity int = 1
param restoreAzureOpenAI bool = false
param privateEndpointsSubnetId string
param privateDnsZoneOpenAIId string

resource aiServices 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: 'aoai-${resourceToken}'
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'OpenAI'
  properties: union(
    restoreAzureOpenAI ? { restore: true } : {},
    {
      customSubDomainName: 'aoai-${resourceToken}'
      publicNetworkAccess: 'Disabled'
      disableLocalAuth: true
      networkAcls: {
        defaultAction: 'Deny'
      }
    }
  )
  tags: tags
}

resource modelDeployment 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01' = {
  parent: aiServices
  name: azureOpenaiModelDeploymentName
  sku: {
    name: 'GlobalStandard'
    capacity: azureOpenaiModelCapacity
  }
  properties: {
    model: union(
      {
        format: 'OpenAI'
        name: azureOpenaiModelName
      },
      azureOpenaiModelVersion != '' ? {
        version: azureOpenaiModelVersion
      } : {}
    )
  }
}

resource openaiPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: 'pe-openai-${resourceToken}'
  location: location
  properties: {
    subnet: {
      id: privateEndpointsSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'openai-connection'
        properties: {
          privateLinkServiceId: aiServices.id
          groupIds: ['account']
        }
      }
    ]
  }
  tags: tags
  dependsOn: [
    modelDeployment
  ]
}

resource openaiDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  parent: openaiPrivateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config'
        properties: {
          privateDnsZoneId: privateDnsZoneOpenAIId
        }
      }
    ]
  }
}

output aiServicesId string = aiServices.id
output aiServicesEndpoint string = aiServices.properties.endpoint
output aiServicesName string = aiServices.name
