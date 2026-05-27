// Private DNS Zone for the Container Apps Environment's internal domain.
// Lives in its own module so the zone name (env.defaultDomain) is passed in as a
// parameter — Bicep can't use runtime values as resource names in the same file,
// but it CAN use module parameters because the inner deployment runs after the
// parent has materialized defaultDomain and staticIp.
//
// Without this zone, <app>.internal.<defaultDomain> does not resolve from inside
// the VNet, so neither the frontend nor backend FQDNs are reachable.

@description('The Container Apps Environment defaultDomain — used as the Private DNS Zone name.')
param defaultDomain string

@description('The Container Apps Environment static IP — the target of the wildcard and apex A records.')
param staticIp string

@description('Resource ID of the VNet to link the zone to.')
param vnetId string

param tags object

resource zone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: defaultDomain
  location: 'global'
  tags: tags
}

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: zone
  name: 'link-aca'
  location: 'global'
  properties: {
    virtualNetwork: { id: vnetId }
    registrationEnabled: false
  }
}

// Wildcard A record covers every app in the env (backend, frontend, future).
resource wildcardA 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: zone
  name: '*'
  properties: {
    ttl: 3600
    aRecords: [
      { ipv4Address: staticIp }
    ]
  }
}

// Apex A record for clients that resolve the bare domain.
resource apexA 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: zone
  name: '@'
  properties: {
    ttl: 3600
    aRecords: [
      { ipv4Address: staticIp }
    ]
  }
}

output zoneId string = zone.id
output zoneName string = zone.name
