// Container Apps Environment + Backend + Frontend Container Apps
// Includes Private DNS Zone for the internal environment domain (required for FQDN resolution inside the VNet)
param location string
param resourceToken string
param backendContainerAppName string
param frontendContainerAppName string
param tags object
param serviceResourceTags object

// Image preservation: every `azd provision` re-applies this template, which would
// overwrite whatever image `azd deploy` last pushed with the placeholder below.
// When these flags are true, we look up the current image on the live container
// app and reuse it. Set to false on the very first provision (resource doesn't
// exist yet), and flip to true in main.bicepparam after the first successful deploy.
@description('Set to true after the first azd deploy of the backend so subsequent provisions preserve the deployed image instead of reverting to the placeholder.')
param backendAppExists bool = false
@description('Set to true after the first azd deploy of the frontend so subsequent provisions preserve the deployed image instead of reverting to the placeholder.')
param frontendAppExists bool = false

var placeholderImage = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

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

// Workload Profiles SKU is required so the infrastructure subnet can be /27.
// A Consumption-only environment requires /23 minimum, which does not fit a /24 VNet.
// We declare only the built-in 'Consumption' profile — apps still run serverless,
// just on the Workload Profiles plane. Add dedicated profiles here later if needed.
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
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
  }
  tags: tags
}

// ─── Private DNS Zone for the internal Container Apps Environment domain ───
// Without this, <app>.internal.<defaultDomain> does not resolve from inside the VNet,
// so neither the frontend nor backend FQDNs are reachable.
//
// The zone, vnet link, and A records live in a sub-module because Bicep can't use
// runtime values (containerAppEnvironment.properties.defaultDomain / staticIp) as
// resource names in the same file (BCP120). Passing them as module parameters works
// — the inner deployment materializes after the parent resource exists.
module acaDns './aca-dns.bicep' = {
  name: 'acaDns'
  params: {
    defaultDomain: containerAppEnvironment.properties.defaultDomain
    staticIp: containerAppEnvironment.properties.staticIp
    vnetId: vnetId
    tags: tags
  }
}

// ─── Existing-image lookups (preserve `azd deploy` artifacts across `azd provision`) ───
resource existingBackendApp 'Microsoft.App/containerApps@2024-03-01' existing = if (backendAppExists) {
  name: backendContainerAppName
}
resource existingFrontendApp 'Microsoft.App/containerApps@2024-03-01' existing = if (frontendAppExists) {
  name: frontendContainerAppName
}

var backendImage = backendAppExists ? existingBackendApp.properties.template.containers[0].image : placeholderImage
var frontendImage = frontendAppExists ? existingFrontendApp.properties.template.containers[0].image : placeholderImage

resource containerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: backendContainerAppName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userManagedIdentityId}': {}
    }
  }
  properties: {
    environmentId: containerAppEnvironment.id
    workloadProfileName: 'Consumption'
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
          name: backendContainerAppName
          image: backendImage
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
            { name: 'OTEL_SERVICE_NAME', value: backendContainerAppName }
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
        // external:true on an internal env = "Limited to VNet" (not internet).
        // Required so App Gateway (which lives in the VNet but outside the ACA env)
        // can reach this app. With external:false the ingress is "Limited to Container
        // Apps Environment" and rejects everything from outside the env → 404.
        external: true
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
          image: frontendImage
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

output backendContainerAppName string = containerApp.name
output containerAppFqdn string = containerApp.properties.configuration.ingress.fqdn
output frontendAppName string = frontendApp.name
output frontendAppFqdn string = frontendApp.properties.configuration.ingress.fqdn
output containerAppEnvironmentId string = containerAppEnvironment.id
output containerAppEnvironmentDefaultDomain string = containerAppEnvironment.properties.defaultDomain
output containerAppEnvironmentStaticIp string = containerAppEnvironment.properties.staticIp
