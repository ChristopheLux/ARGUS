// ARGUS — Bicep parameters file (single source of truth)
//
// This file replaces the legacy main.parameters.json. azd picks it up automatically
// when it sits next to main.bicep, and it lets us use real Bicep expressions
// (readEnvironmentVariable, conditionals, etc.) instead of string-substitution
// tokens. Keep only one parameters file in infra/ — having both confuses azd:
// older versions silently prefer the JSON, which is how `param deployAppGateway = true`
// was being ignored before.

using './main.bicep'

// ─── Required (sourced from the azd environment) ──────────────────
// `azd env set <NAME> <VALUE>` populates these. azd also writes
// AZURE_ENV_NAME, AZURE_LOCATION, and AZURE_PRINCIPAL_ID automatically
// during `azd up` / `azd provision`, so a fresh clone Just Works.
param environmentName = readEnvironmentVariable('AZURE_ENV_NAME', 'argus-dev')
param location = readEnvironmentVariable('AZURE_LOCATION', 'westeurope')
param azurePrincipalId = readEnvironmentVariable('AZURE_PRINCIPAL_ID', '')

// ─── Network ──────────────────────────────────────────────────────
// Default /24 (256 addresses) carves into:
//   .0/27   → Container Apps env (Workload Profiles SKU, 32 IPs)
//   .32/27  → Private endpoints   (32 IPs)
//   .64/26  → Application Gateway (64 IPs, only populated when deployAppGateway = true)
// Set AZURE_VNET_ADDRESS_SPACE in the azd env to override (e.g. for landing-zone peering).
param vnetAddressSpace = readEnvironmentVariable('AZURE_VNET_ADDRESS_SPACE', '10.0.0.0/24')

// ─── App Gateway / WAF toggle ────────────────────────────────────
// `azd env set DEPLOY_APP_GATEWAY true` to bring up an internet-facing WAF_v2
// (OWASP 3.2, Prevention mode) in front of the internal frontend. Leave unset
// or 'false' for a fully-private deployment reachable only via VPN/Bastion.
param deployAppGateway = toLower(readEnvironmentVariable('DEPLOY_APP_GATEWAY', 'false')) == 'true'

// ─── OpenAI model (optional overrides) ────────────────────────────
// Default is gpt-4.1 — the minimum model recommended for ARGUS extraction quality.
// Override per-environment with: azd env set AZURE_OPENAI_MODEL_NAME <model>
param azureOpenaiModelName = readEnvironmentVariable('AZURE_OPENAI_MODEL_NAME', 'gpt-4.1')
param azureOpenaiModelVersion = readEnvironmentVariable('AZURE_OPENAI_MODEL_VERSION', '')
param azureOpenaiModelDeploymentName = readEnvironmentVariable('AZURE_OPENAI_MODEL_DEPLOYMENT_NAME', 'aoai-deploy')

// ─── Restore flags (only for re-creating soft-deleted resources) ──
// Flip to 'true' in the azd env when redeploying after a tenant cleanup
// purged the Cognitive Services account but the soft-delete window is still open.
param restoreDocumentIntelligence = toLower(readEnvironmentVariable('RESTORE_DOCUMENT_INTELLIGENCE', 'false')) == 'true'
param restoreAzureOpenAI = toLower(readEnvironmentVariable('RESTORE_AZURE_OPENAI', 'false')) == 'true'
