// Container Apps Environment + Backend + Frontend Container Apps
// Includes Private DNS Zone for the internal environment domain (required for FQDN resolution inside the VNet)
param location string
param resourceToken string
param containerAppName string
param frontendContainerAppName string
param tags object
param serviceResourceTags object

// Monitoring
param logAnalyticsCustomerId string
@secure()
param logAnalyticsSharedKey string
param applicationInsightsConnectionString string

// Identity
param userManagedIdentityId string
param userManagedIdentityClientId string

// Container Registry
param containerRegistryLoginServer string

// Storage
param storageAccountName string
param blobEndpoint string
param containerName string

// Cosmos DB
param cosmosEndpoint string
param cosmosDatabaseName string
param cosmosContainerName string
param cosmosConfigContainerName string

// Document Intelligence
param documentIntelligenceEndpoint string

// AI Services
param aiServicesEndpoint string
param azureOpenaiModelDeploymentName string

// Key Vault
param keyVaultUri string

// VNet
param containerAppsSubnetId string
@description('Resource ID of the VNet that hosts the Container Apps subnet. Used to link the ACA private DNS zone so the internal FQDN resolves.')
param vnetId string

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: 'cae-${resourceToken}'
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsCustomerId
        sharedKey: logAnalyticsSharedKey
      }
    }
    vnetConfiguration: {
      infrastructureSubnetId: containerAppsSubnetId
      internal: true
    }
  }
  tags: tags
}

// ─── Private DNS Zone for the internal Container Apps Environment domain ───
// Without this, <app>.internal.<defaultDomain> does not resolve from inside the VNet,
// so neither the frontend nor backend FQDNs are reachable.
resource acaPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: containerAppEnvironment.properties.defaultDomain
  location: 'global'
  tags: tags
}

resource acaPrivateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: acaPrivateDnsZone
  name: 'link-aca'
  location: 'global'
  properties: {
    virtualNetwork: { id: vnetId }
    registrationEnabled: false
  }
}

// Wildcard A record points every app in the environment at the env's static IP.
// Covers backend, frontend, and any future apps with a single record.
resource acaWildcardARecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: acaPrivateDnsZone
  name: '*'
  properties: {
    ttl: 3600
    aRecords: [
      { ipv4Address: containerAppEnvironment.properties.staticIp }
    ]
  }
}

// Some clients also need the apex record (e.g. for the env's wildcard certificate validation paths)
resource acaApexARecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: acaPrivateDnsZone
  name: '@'
  properties: {
    ttl: 3600
    aRecords: [
      { ipv4Address: containerAppEnvironment.properties.staticIp }
    ]
  }
}

resource containerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: containerAppName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userManagedIdentityId}': {}
    }
  }
  properties: {
    environmentId: containerAppEnvironment.id
    configuration: {
      ingress: {
        external: false
        targetPort: 8000
        corsPolicy: {
          allowedOrigins: ['*']
          allowedMethods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS']
          allowedHeaders: ['*']
          maxAge: 3600
        }
      }
      registries: [
        {
          server: containerRegistryLoginServer
          identity: userManagedIdentityId
        }
      ]
    }
    template: {
      containers: [
        {
          name: containerAppName
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          resources: {
            cpu: json('1.0')
            memory: '2Gi'
          }
          env: [
            { name: 'STORAGE_ACCOUNT_NAME', value: storageAccountName }
            { name: 'BLOB_ACCOUNT_URL', value: blobEndpoint }
            { name: 'CONTAINER_NAME', value: containerName }
            { name: 'COSMOS_URL', value: cosmosEndpoint }
            { name: 'COSMOS_DB_NAME', value: cosmosDatabaseName }
            { name: 'COSMOS_DOCUMENTS_CONTAINER_NAME', value: cosmosContainerName }
            { name: 'COSMOS_CONFIG_CONTAINER_NAME', value: cosmosConfigContainerName }
            { name: 'DOCUMENT_INTELLIGENCE_ENDPOINT', value: documentIntelligenceEndpoint }
            { name: 'AZURE_OPENAI_ENDPOINT', value: aiServicesEndpoint }
            { name: 'AZURE_OPENAI_MODEL_DEPLOYMENT_NAME', value: azureOpenaiModelDeploymentName }
            { name: 'APPLICATIONINSIGHTS_CONNECTION_STRING', value: applicationInsightsConnectionString }
            { name: 'AZURE_CLIENT_ID', value: userManagedIdentityClientId }
            { name: 'AZURE_SUBSCRIPTION_ID', value: subscription().subscriptionId }
            { name: 'AZURE_RESOURCE_GROUP_NAME', value: resourceGroup().name }
            { name: 'LOGIC_APP_NAME', value: 'logic-argus-v2-${resourceToken}' }
            { name: 'AZURE_STORAGE_ACCOUNT_NAME', value: storageAccountName }
            { name: 'AZURE_KEY_VAULT_URI', value: keyVaultUri }
            // OpenTelemetry + GenAI tracing
            { name: 'OTEL_SERVICE_NAME', value: containerAppName }
            { name: 'OTEL_TRACES_EXPORTER', value: 'otlp' }
            { name: 'OTEL_METRICS_EXPORTER', value: 'otlp' }
            { name: 'OTEL_LOGS_EXPORTER', value: 'otlp' }
            { name: 'OTEL_EXPORTER_OTLP_ENDPOINT', value: 'https://dc.applicationinsights.azure.com/v2/track' }
            { name: 'OTEL_PYTHON_LOGGING_AUTO_INSTRUMENTATION_ENABLED', value: 'true' }
            { name: 'SEMANTICKERNEL_EXPERIMENTAL_GENAI_ENABLE_OTEL_DIAGNOSTICS', value: 'true' }
            { name: 'SEMANTICKERNEL_EXPERIMENTAL_GENAI_ENABLE_OTEL_DIAGNOSTICS_SENSITIVE', value: 'false' }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 5
        rules: [
          {
            name: 'http-rule'
            http: {
              metadata: {
                concurrentRequests: '10'
              }
            }
          }
        ]
      }
    }
  }
  tags: serviceResourceTags
}

resource frontendApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: frontendContainerAppName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userManagedIdentityId}': {}
    }
  }
  properties: {
    environmentId: containerAppEnvironment.id
    configuration: {
      ingress: {
        external: false
        targetPort: 3000
      }
      registries: [
        {
          server: containerRegistryLoginServer
          identity: userManagedIdentityId
        }
      ]
    }
    template: {
      containers: [
        {
          name: frontendContainerAppName
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          resources: {
            cpu: json('1.0')
            memory: '2Gi'
          }
          env: [
            { name: 'BLOB_ACCOUNT_URL', value: blobEndpoint }
            { name: 'CONTAINER_NAME', value: containerName }
            { name: 'COSMOS_URL', value: cosmosEndpoint }
            { name: 'COSMOS_DB_NAME', value: cosmosDatabaseName }
            { name: 'COSMOS_DOCUMENTS_CONTAINER_NAME', value: cosmosContainerName }
            { name: 'COSMOS_CONFIG_CONTAINER_NAME', value: cosmosConfigContainerName }
            { name: 'AZURE_CLIENT_ID', value: userManagedIdentityClientId }
            { name: 'BACKEND_URL', value: 'https://${containerApp.properties.configuration.ingress.fqdn}' }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 5
        rules: [
          {
            name: 'http-rule'
            http: {
              metadata: {
                concurrentRequests: '10'
              }
            }
          }
        ]
      }
    }
  }
  tags: union(tags, { 'azd-service-name': 'frontend' })
}

output containerAppName string = containerApp.name
output containerAppFqdn string = containerApp.properties.configuration.ingress.fqdn
output frontendAppName string = frontendApp.name
output frontendAppFqdn string = frontendApp.properties.configuration.ingress.fqdn
output containerAppEnvironmentId string = containerAppEnvironment.id
output containerAppEnvironmentDefaultDomain string = containerAppEnvironment.properties.defaultDomain
output containerAppEnvironmentStaticIp string = containerAppEnvironment.properties.staticIp
