using './main.bicep'

// Deployment configuration
param location = 'swedencentral' // Azure region for resource deployment
param environmentName = 'dev'

// Subscription (defaults to current subscription)
param subscriptionId = '' // Leave empty to use current subscription, or set to explicit subscription ID

// Resource naming
param containerAppName = 'ca-argus-backend'
param frontendContainerAppName = 'ca-argus-frontend'
param cosmosDbDatabaseName = 'doc-extracts'
param cosmosDbContainerName = 'documents'
param azureOpenaiModelName = 'gpt-4o-mini'

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
