using './main.bicep'

// Deployment configuration
param location = 'eastus'
param environmentName = 'dev'

// Resource naming
param containerAppName = 'ca-argus-backend'
param frontendContainerAppName = 'ca-argus-frontend'
param storageAccountName = 'saargusdev'
param cosmosDbAccountName = 'cbargusdev'
param cosmosDbDatabaseName = 'doc-extracts'
param cosmosDbContainerName = 'documents'
param containerRegistryName = 'crargudev'
param documentIntelligenceName = 'diargusdev'
param azureOpenaiModelDeploymentName = 'gpt-5.4'

// Identity and RBAC
param azurePrincipalId = '' // Set to your user/service principal ID

// Network configuration (VNet and subnets)
// Default: 10.0.0.0/16 VNet with 10.0.0.0/21 for Container Apps, 10.0.8.0/24 for Private Endpoints
param vnetAddressSpace = '10.0.0.0/16'
param containerAppsSubnetAddressPrefix = '10.0.0.0/21'
param privateEndpointsSubnetAddressPrefix = '10.0.8.0/24'

// Example override for a different network:
// param vnetAddressSpace = '192.168.0.0/16'
// param containerAppsSubnetAddressPrefix = '192.168.0.0/21'
// param privateEndpointsSubnetAddressPrefix = '192.168.8.0/24'
