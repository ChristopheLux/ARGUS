// Log Analytics + Application Insights
param location string
param resourceToken string
param tags object
param privateEndpointsSubnetId string
param privateDnsZoneMonitorId string
param privateDnsZoneLogAnalyticsId string
param privateDnsZoneOmsId string

@description('Hardening mode: none = leave public access enabled; disablePublicAfterPrivate = two-phase hardening.')
@allowed([
  'none'
  'disablePublicAfterPrivate'
])
param hardeningMode string = 'disablePublicAfterPrivate'

var harden = hardeningMode == 'disablePublicAfterPrivate'
var initialPublicAccess = harden ? 'Enabled' : 'Enabled' // phase 1 always enabled if hardening; otherwise keep enabled
var finalPublicAccess = harden ? 'Disabled' : 'Enabled'


resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'law-${resourceToken}'
  location: location
  properties: {
    retentionInDays: 30
    publicNetworkAccessForIngestion: initialPublicAccess 
    publicNetworkAccessForQuery: initialPublicAccess 
  }
  tags: tags
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'ai-${resourceToken}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
    publicNetworkAccessForIngestion: initialPublicAccess 
    publicNetworkAccessForQuery: initialPublicAccess 
  }
  tags: tags
  
}

resource monitorPrivateLinkScope 'Microsoft.Insights/privateLinkScopes@2023-06-01-preview' = {
  name: 'mls-${resourceToken}'
  location: 'global'
  properties: {
    accessModeSettings: {
      ingestionAccessMode: 'PrivateOnly'
      queryAccessMode: 'PrivateOnly'
    }
  }
  tags: tags
}

resource monitorPrivateLinkScopeLogAnalytics 'Microsoft.Insights/privateLinkScopes/scopedResources@2023-06-01-preview' = {
  parent: monitorPrivateLinkScope
  name: 'la-${resourceToken}'
  properties: {
    kind: 'Resource'
    linkedResourceId: logAnalytics.id
  }
  

}

resource monitorPrivateLinkScopeAppInsights 'Microsoft.Insights/privateLinkScopes/scopedResources@2023-06-01-preview' = {
  parent: monitorPrivateLinkScope
  name: 'ai-${resourceToken}'
  properties: {
    kind: 'Resource'
    linkedResourceId: applicationInsights.id
  }
  

}

resource monitorPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: 'pe-monitor-${resourceToken}'
  location: location
  properties: {
    subnet: {
      id: privateEndpointsSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'monitorConnection'
        properties: {
          privateLinkServiceId: monitorPrivateLinkScope.id
          groupIds: [
            'azuremonitor'
          ]
          requestMessage: 'Auto-approved by deployment'
        }
      }
    ]
  }
  tags: tags
dependsOn: [
    monitorPrivateLinkScopeLogAnalytics
    monitorPrivateLinkScopeAppInsights
  ]

}

resource monitorDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  parent: monitorPrivateEndpoint
  name: 'default'
  properties: {
   
privateDnsZoneConfigs: [
  {
    name: 'monitorConfig'
    properties: {
      privateDnsZoneId: privateDnsZoneMonitorId
    }
  }
  {
    name: 'odsConfig'
    properties: {
      privateDnsZoneId: privateDnsZoneLogAnalyticsId
    }
  }
  {
    name: 'omsConfig'
    properties: {
      privateDnsZoneId: privateDnsZoneOmsId
    }
  }
]

  }
}

resource logAnalyticsHardened 'Microsoft.OperationalInsights/workspaces@2021-06-01' = if (harden) {
  name: logAnalytics.name
  location: location
  properties: {
    retentionInDays: 30
    publicNetworkAccessForIngestion: finalPublicAccess
    publicNetworkAccessForQuery: finalPublicAccess
  }
  tags: tags
  dependsOn: [
    monitorDnsGroup
  ]
}

resource applicationInsightsHardened 'Microsoft.Insights/components@2020-02-02' = if (harden) {
  name: applicationInsights.name
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
    publicNetworkAccessForIngestion: finalPublicAccess
    publicNetworkAccessForQuery: finalPublicAccess
  }
  tags: tags
  dependsOn: [
    monitorDnsGroup
  ]
}


output logAnalyticsId string = logAnalytics.id
output logAnalyticsCustomerId string = logAnalytics.properties.customerId
#disable-next-line outputs-should-not-contain-secrets
output logAnalyticsSharedKey string = logAnalytics.listKeys().primarySharedKey
output applicationInsightsConnectionString string = applicationInsights.properties.ConnectionString
output applicationInsightsId string = applicationInsights.id
