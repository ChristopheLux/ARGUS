// Application Gateway v2 with WAF (OWASP 3.2, Prevention mode)
// Internet-facing entry point that forwards HTTPS traffic to the internal frontend
// container app. Lives in its own subnet inside the same VNet, so it can resolve the
// ACA env's internal FQDN through the Private DNS Zone created in network.bicep.
//
// This module is deployed only when main.bicep's deployAppGateway = true.

param location string
param resourceToken string
param tags object

@description('Resource ID of the dedicated App Gateway subnet (from network module).')
param appGatewaySubnetId string

@description('Internal FQDN of the frontend container app — backend pool target.')
param frontendFqdn string

var appGatewayName = 'agw-${resourceToken}'
var wafPolicyName = 'waf-${resourceToken}'
var publicIpName = 'pip-agw-${resourceToken}'

// ─── WAF Policy ──────────────────────────────────────────────────
resource wafPolicy 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2023-11-01' = {
  name: wafPolicyName
  location: location
  tags: tags
  properties: {
    policySettings: {
      state: 'Enabled'
      mode: 'Prevention'
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 100
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
        }
      ]
    }
  }
}

// ─── Public IP ───────────────────────────────────────────────────
resource publicIp 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: publicIpName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: 'agw-${resourceToken}'
    }
  }
}

// ─── Application Gateway (WAF_v2) ───────────────────────────────
resource appGateway 'Microsoft.Network/applicationGateways@2023-11-01' = {
  name: appGatewayName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'WAF_v2'
      tier: 'WAF_v2'
    }
    autoscaleConfiguration: {
      minCapacity: 1
      maxCapacity: 3
    }
    firewallPolicy: {
      id: wafPolicy.id
    }
    gatewayIPConfigurations: [
      {
        name: 'agwIpConfig'
        properties: {
          subnet: {
            id: appGatewaySubnetId
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'agwFrontendIp'
        properties: {
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'frontendBackendPool'
        properties: {
          backendAddresses: [
            {
              fqdn: frontendFqdn
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'frontendHttpsSettings'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          hostName: frontendFqdn
          requestTimeout: 30
          probe: {
            id: resourceId('Microsoft.Network/applicationGateways/probes', appGatewayName, 'frontendHealthProbe')
          }
        }
      }
    ]
    probes: [
      {
        name: 'frontendHealthProbe'
        properties: {
          protocol: 'Https'
          host: frontendFqdn
          path: '/'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          match: {
            statusCodes: [
              '200-399'
            ]
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'httpListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', appGatewayName, 'agwFrontendIp')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', appGatewayName, 'port80')
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'httpRoutingRule'
        properties: {
          ruleType: 'Basic'
          priority: 100
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', appGatewayName, 'httpListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', appGatewayName, 'frontendBackendPool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', appGatewayName, 'frontendHttpsSettings')
          }
        }
      }
    ]
  }
}

output appGatewayId string = appGateway.id
output appGatewayName string = appGateway.name
output appGatewayPublicIp string = publicIp.properties.ipAddress
output appGatewayFqdn string = publicIp.properties.dnsSettings.fqdn
