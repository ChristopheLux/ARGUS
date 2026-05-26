// ARGUS — Bicep parameters file
// Only the params you actually need to set live here. Everything else is
// derived inside main.bicep (resource names, subnet prefixes, tokens, etc.).

using './main.bicep'

// ─── Required ─────────────────────────────────────────────────────
// Used in resource tagging and the azd environment name.
param environmentName = 'argus-dev'

// Object ID of the user (or service principal) running the deployment.
// Receives data-plane RBAC roles for Cosmos, Storage, Document Intelligence, etc.
param azurePrincipalId = '00000000-0000-0000-0000-000000000000'

// ─── Optional ────────────────────────────────────────────────────
// param location = 'westeurope'

// VNet address space. The three subnets (Container Apps /21, Private Endpoints /24,
// App Gateway /24) are carved out of this automatically via cidrSubnet().
// Default 10.0.0.0/16 works for greenfield deployments. Override only when peering
// into an existing landing zone with a fixed CIDR block.
// param vnetAddressSpace = '10.0.0.0/16'

// ─── App Gateway / WAF toggle ────────────────────────────────────
// Set to true to deploy an internet-facing Application Gateway (WAF_v2, OWASP 3.2,
// Prevention mode) in front of the frontend container app. The gateway lives in
// the snet-app-gateway subnet, terminates HTTP on a public IP, and forwards HTTPS
// to the frontend's internal FQDN via the private DNS zone.
//
// Leave false for a fully-private deployment reachable only via VPN, Bastion,
// or Front Door with a private origin.
param deployAppGateway = false

// ─── OpenAI model (optional overrides) ────────────────────────────
// param azureOpenaiModelName = 'gpt-35-turbo'
// param azureOpenaiModelVersion = ''
// param azureOpenaiModelCapacity = 1

// ─── Restore flags (only for re-creating soft-deleted resources) ──
// param restoreDocumentIntelligence = false
// param restoreAzureOpenAI = false
