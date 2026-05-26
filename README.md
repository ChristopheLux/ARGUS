# 👁️ ARGUS: The All-Seeing Document Intelligence Platform

<div align="center">

[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com)
[![OpenAI](https://img.shields.io/badge/GPT--35--Turbo-412991?style=for-the-badge&logo=openai&logoColor=white)](https://openai.com)
[![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![Next.js](https://img.shields.io/badge/Next.js-000000?style=for-the-badge&logo=next.js&logoColor=white)](https://nextjs.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

*Named after Argus Panoptes, the mythological giant with a hundred eyes—ARGUS never misses a detail in your documents.*

</div>

## 🚀 Transform Document Processing with AI Intelligence

**ARGUS** revolutionizes how organizations extract, understand, and act on document data. By combining the precision of **Azure Document Intelligence** with the contextual reasoning of **GPT-35-Turbo**, ARGUS doesn't just read documents—it *understands* them.

### 💡 Why ARGUS?

Traditional OCR solutions extract text but miss the context. AI-only approaches struggle with complex layouts. **ARGUS bridges this gap**, delivering enterprise-grade document intelligence that:

- **🎯 Extracts with Purpose**: Understands document context, not just text
- **⚡ Scales Effortlessly**: Process thousands of documents with cloud-native architecture
- **🔒 Secures by Design**: Enterprise security with managed identities and RBAC
- **🧠 Learns Continuously**: Configurable datasets adapt to your specific document types
- **📊 Measures Success**: Built-in evaluation tools ensure consistent accuracy

---

## 🌟 Key Capabilities

<table>
<tr>
<td width="50%">

### 🔍 **Intelligent Document Understanding**
- **Hybrid AI Pipeline**: Combines OCR precision with LLM reasoning
- **Multiple OCR Providers**: Azure Document Intelligence or Mistral Document AI
- **Context-Aware Extraction**: Understands relationships between data points
- **Multi-Format Support**: PDFs, images, forms, invoices, medical records
- **Zero-Shot Learning**: Works on new document types without training

### ⚡ **Enterprise-Ready Performance**
- **Cloud-Native Architecture**: Built on Azure Container Apps with VNet integration
- **Scalable Processing**: Handle document floods with confidence
- **Real-Time Processing**: API-driven workflows for immediate results
- **Event-Driven Automation**: Automatic processing on document upload
- **Zero-Credential Security**: Managed identity authentication with no API keys

</td>
<td width="50%">

### 🎛️ **Advanced Control & Customization**
- **Dynamic Configuration**: Runtime settings without redeployment
- **Custom Datasets**: Tailor extraction for your specific needs
- **Interactive Chat**: Ask questions about processed documents
- **Concurrency Management**: Fine-tune performance for your workload

### 📈 **Comprehensive Analytics**
- **Built-in Evaluation**: Multiple accuracy metrics and comparisons
- **Performance Monitoring**: Application Insights integration
- **Custom Evaluators**: Fuzzy matching, semantic similarity, and more
- **Visual Analytics**: Jupyter notebooks for deep analysis

</td>
</tr>
</table>

---

## 🏗️ Architecture: Built for Scale and Security

ARGUS employs a modern, cloud-native architecture designed for enterprise workloads:

<div align="center">

```mermaid
graph TB
    subgraph "📥 Document Input"
        A[📄 Documents] --> B[📁 Azure Blob Storage]
        C[🌐 Direct Upload API] --> D[🚀 FastAPI Backend]
    end
    
    subgraph "🧠 AI Processing Engine"
        B --> D
        D --> E{🔍 OCR Provider}
        E -->|Azure| E1[Azure Document Intelligence]
        E -->|Mistral| E2[Mistral Document AI]
        D --> F[🤖 GPT-35-Turbo]
        E1 --> G[⚙️ Hybrid Processing Pipeline]
        E2 --> G
        F --> G
    end
    
    subgraph "💡 Intelligence & Analytics"
        G --> H[📊 Custom Evaluators]
        G --> I[💬 Interactive Chat]
        H --> J[📈 Results & Analytics]
    end
    
    subgraph "💾 Data Layer"
        G --> K[🗄️ Azure Cosmos DB]
        J --> K
        I --> K
        K --> L[📱 Next.js Frontend]
    end
    
    style A fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    style B fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    style C fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    style D fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    style E fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    style E1 fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    style E2 fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    style F fill:#e0f2f1,stroke:#00695c,stroke-width:2px
    style G fill:#fff8e1,stroke:#ffa000,stroke-width:2px
    style H fill:#f1f8e9,stroke:#558b2f,stroke-width:2px
    style I fill:#e8eaf6,stroke:#3f51b5,stroke-width:2px
    style J fill:#fdf2e9,stroke:#e65100,stroke-width:2px
    style K fill:#e0f7fa,stroke:#0097a7,stroke-width:2px
    style L fill:#f9fbe7,stroke:#827717,stroke-width:2px
```

</div>

### 🔧 Infrastructure Components

> The deployment is configured for a fully private Azure architecture. Log Analytics, Application Insights, OpenAI, Cosmos DB, Storage, Key Vault, and Document Intelligence are all connected through private endpoints and private DNS zones. **Azure Container Registry is intentionally left public** (the only public component) so the Azure Developer CLI and CI pipelines can push images without a self-hosted agent or VPN. An **optional Application Gateway with WAF** can be enabled as a public entry point in front of the internal frontend.

| Component | Technology | Purpose |
|-----------|------------|---------|
| **🚀 Backend API** | Azure Container Apps + FastAPI | High-performance document processing engine |
| **📱 Frontend UI** | Next.js (React) | Modern document management interface |
| **📁 Document Storage** | Azure Blob Storage | Secure, scalable document repository |
| **🗄️ Metadata Database** | Azure Cosmos DB | Results, configurations, and analytics |
| **🔍 OCR Engine** | Azure Document Intelligence or Mistral Document AI | Structured text and layout extraction |
| **🧠 AI Reasoning** | Azure OpenAI (GPT-35-Turbo) | Contextual understanding and extraction |
| **🏗️ Container Registry** | Azure Container Registry | Container images (public by design — only public component, enables `azd` / CI image push) |
| **🔒 Security** | Managed Identity + RBAC | Zero-credential architecture |
| **🌐 Network** | VNet + Private Endpoints | Network isolation for all Azure services |
| **🔑 Secrets** | Azure Key Vault | Centralized secrets management |
| **📊 Monitoring** | Application Insights (private endpoint) | Performance and health monitoring with private telemetry access |
| **🛡️ Application Gateway (optional)** | Application Gateway WAF_v2 + OWASP 3.2 | Optional internet-facing entry point in front of the internal frontend — enabled with a single boolean |

---

## 🔒 Security Architecture

ARGUS implements a defense-in-depth security model:

### Network Isolation
- **VNet Integration**: All Container Apps run within a dedicated Virtual Network (default `10.0.0.0/16`, carved into three subnets automatically)
- **Single network parameter**: One `vnetAddressSpace` param drives the whole layout — the three subnets are derived inside `network.bicep` via `cidrSubnet()`, so they can never overlap or drift
  - `/21` Container Apps subnet (delegated to `Microsoft.App/environments`, ~2,000 IPs)
  - `/24` Private Endpoints subnet
  - `/24` Application Gateway subnet (always created, only populated when `deployAppGateway = true`)
- **Private Endpoints**: Storage, Cosmos DB, OpenAI, Document Intelligence, Key Vault, Log Analytics, and Application Insights are accessible only through private endpoints
- **Private DNS Zones**: Automatic DNS resolution for private endpoints via Azure Private DNS, including a wildcard zone for the Container Apps environment's `defaultDomain`
- **No Public Access**: All backend services have `publicNetworkAccess: Disabled`
- **ACR exception**: Azure Container Registry is intentionally public — image pulls flow outbound from the Container Apps data plane, and image pushes from `azd` / CI need a reachable endpoint
- **Optional WAF entry point**: Set `deployAppGateway = true` to bring an internet-facing Application Gateway (WAF_v2, OWASP 3.2, Prevention mode) in front of the internal frontend. Leave it `false` for a fully-private deployment reachable only via VPN, Bastion, or Front Door with a private origin

### Identity & Authentication
- **Managed Identity**: User-assigned managed identity for all service-to-service authentication
- **No API Keys**: Local authentication is disabled on all Azure services (`disableLocalAuth: true`)
- **No Shared Keys**: Storage account shared key access is disabled (`allowSharedKeyAccess: false`)
- **RBAC-Only Access**: All permissions are granted through Azure RBAC role assignments

### RBAC Roles (Principle of Least Privilege)
| Role | Scope | Purpose |
|------|-------|---------|
| Storage Blob Data Contributor | Storage Account | Read/write blob data |
| Cosmos DB Built-in Data Contributor | Cosmos DB Account | Read/write database items |
| Cognitive Services User | Document Intelligence | OCR operations |
| Cognitive Services OpenAI User | Azure OpenAI | Model inference |
| Key Vault Secrets User | Key Vault | Read secrets |
| AcrPull | Container Registry | Pull container images |

---

## ⚡ Quick Start: Deploy in Minutes

### � Switch the Azure OpenAI model
The default model is `gpt-35-turbo` for broad availability. To change it, update `azureOpenaiModelName` in `infra/main.bicep` or set `AZURE_OPENAI_MODEL_NAME` in `infra/main.parameters.json`. If you need a specific version, also set `azureOpenaiModelVersion`.

> Private deployment note: ARGUS is architected to keep OpenAI, monitoring, storage, and database traffic inside Azure using private endpoints and Private DNS zones. Monitoring telemetry flows through Application Insights with private endpoint access only.

### �📋 Prerequisites

<details>
<summary><b>🛠️ Required Tools (Click to expand)</b></summary>

1. **Docker**
   ```bash
   # Install Docker (required for containerization during deployment)
   # Visit https://docs.docker.com/get-docker/ for installation instructions
   ```

2. **Azure Developer CLI (azd)**
   ```bash
   curl -fsSL https://aka.ms/install-azd.sh | bash
   ```

3. **Azure CLI**
   ```bash
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   ```

4. **Azure Subscription**
   - An active Azure subscription with permissions to create resources
   - The deployment automatically provisions all required Azure services (OpenAI, Storage, Cosmos DB, etc.)
   - Authentication uses managed identity — no API keys required

</details>

### 🚀 One-Command Deployment

```bash
# 1. Clone the repository
git clone https://github.com/Azure-Samples/ARGUS.git
cd ARGUS

# 2. Login to Azure
az login

# 3. Deploy everything with a single command
azd up
```

**That's it!** 🎉 Your ARGUS instance is now running in the cloud.

### ✅ Verify Your Deployment

```bash
# Check system health
curl "$(azd env get-value BACKEND_URL)/health"

# Expected response:
{
  "status": "healthy",
  "services": {
    "cosmos_db": "✅ connected",
    "blob_storage": "✅ connected", 
    "document_intelligence": "✅ connected",
    "azure_openai": "✅ connected"
  }
}

# View live application logs
azd logs --follow
```

---

## 🎮 Usage Examples: See ARGUS in Action

### 📄 Method 1: Upload via Frontend Interface (Recommended)

The easiest way to process documents is through the user-friendly web interface:

1. **Access the Frontend**:
   ```bash
   # Get the frontend URL after deployment
   azd env get-value FRONTEND_URL
   ```

2. **Upload and Process Documents**:
   - Navigate to the **"🧠 Process Files"** tab
   - Select your dataset from the dropdown (e.g., "default-dataset", "medical-dataset")
   - Use the **file uploader** to select PDF, image, or Office documents
   - Click **"Submit"** to upload files
   - Files are automatically processed using the selected dataset's configuration
   - Monitor processing status in the **"🔍 Explore Data"** tab

### 📤 Method 2: Direct Blob Storage Upload

For automation or bulk processing, upload files directly to Azure Blob Storage:

```bash
# Upload a document to be processed automatically
az storage blob upload \
  --account-name "$(azd env get-value STORAGE_ACCOUNT_NAME)" \
  --container-name "datasets" \
  --name "default-dataset/invoice-2024.pdf" \
  --file "./my-invoice.pdf" \
  --auth-mode login

# Files uploaded to blob storage are automatically detected and processed
# Results can be viewed in the frontend or retrieved via API
```

### 💬 Example 3: Interactive Document Chat

Ask questions about any processed document through the API:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "blob_url": "https://mystorage.blob.core.windows.net/datasets/default-dataset/contract.pdf",
    "question": "What are the key terms and conditions in this contract?"
  }' \
  "$(azd env get-value BACKEND_URL)/api/chat"

# Get intelligent answers:
{
  "answer": "The key terms include: 1) 12-month service agreement, 2) $5000/month fee, 3) 30-day termination clause...",
  "confidence": 0.91,
  "sources": ["page 1, paragraph 3", "page 2, section 2.1"]
}
```

---

## 🤖 MCP Integration: AI-Powered Document Access

ARGUS supports the **Model Context Protocol (MCP)** using the modern **Streamable HTTP transport**, enabling AI assistants like GitHub Copilot, Claude, and other MCP-compatible clients to interact directly with your document intelligence platform.

### 🔌 What is MCP?

The [Model Context Protocol](https://modelcontextprotocol.io/) is an open standard that allows AI assistants to securely connect to external data sources and tools. With ARGUS MCP support, your AI assistant can:

- 📄 **List and search documents** across all your datasets
- 🔍 **Query document content** and extracted data
- 💬 **Chat with documents** using natural language
- 📤 **Upload new documents** for processing
- ⚙️ **Manage datasets** and configurations

### ⚡ Quick Setup

Add ARGUS to your MCP client configuration:

**VS Code / GitHub Copilot** (`~/.vscode/mcp.json` or workspace settings):
```json
{
  "mcpServers": {
    "argus": {
      "url": "https://<your-backend-url>/mcp"
    }
  }
}
```

> **Tip**: After deployment with `azd up`, get your backend URL from the Azure Portal or run `azd show` to find the Container App URL.

**Claude Desktop** (`~/Library/Application Support/Claude/claude_desktop_config.json`):
```json
{
  "mcpServers": {
    "argus": {
      "url": "https://<your-backend-url>/mcp"
    }
  }
}
```

> **Note**: ARGUS uses the Streamable HTTP transport (the modern MCP standard). The endpoint is a single `/mcp` path that handles all MCP communication.

### 🛠️ Available MCP Tools

| Tool | Description |
|------|-------------|
| `argus_list_documents` | List all processed documents with filtering options |
| `argus_get_document` | Get detailed document information including OCR and extraction results |
| `argus_chat_with_document` | Ask natural language questions about a document |
| `argus_search_documents` | Search documents by keyword across all datasets |
| `argus_list_datasets` | List available dataset configurations |
| `argus_get_dataset_config` | Get system prompt and schema for a dataset |
| `argus_create_dataset` | Create a new dataset with custom prompt and schema |
| `argus_process_document_url` | Queue a document for processing from blob URL |
| `argus_get_extraction` | Get extracted structured data from a document |
| `argus_get_upload_url` | Get a pre-signed SAS URL for direct document upload |

### 💡 Example Interactions

Once configured, you can interact with ARGUS through your AI assistant:

```
User: "Show me all invoices processed in the last week"
AI: [Uses argus_list_documents to retrieve recent invoices]

User: "What's the total amount on invoice INV-2024-001?"
AI: [Uses argus_get_document to fetch invoice details]

User: "I need to upload a new contract for processing"
AI: [Uses argus_get_upload_url to get a secure upload link]

User: "Compare the extraction results between these two invoices"
AI: [Uses argus_get_extraction on both documents and compares]

User: "Create a new dataset for processing purchase orders"
AI: [Uses argus_create_dataset with appropriate prompt and schema]
```


---

## 🎛️ Advanced Configuration

### � Infrastructure & Deployment: Private-Only Architecture

ARGUS implements a **hardened, private-only infrastructure** on the `hardening/private-only` branch where all Azure services are accessible exclusively through private endpoints. This ensures maximum security by eliminating public internet exposure.

#### 🛡️ Private-Only Architecture Features

**Network Isolation**
- ✅ **Virtual Network (VNet)**: All services deployed within an isolated VNet (`10.0.0.0/16` by default) with three derived subnets — Container Apps `/21`, Private Endpoints `/24`, Application Gateway `/24`
- ✅ **Private Endpoints**: Storage, Cosmos DB, OpenAI, Document Intelligence, Key Vault, Log Analytics, and Application Insights are accessible ONLY via private endpoints
- ✅ **No Public Access**: All backing PaaS services have `publicNetworkAccess: Disabled`
- ⚠️ **ACR is public by design**: Container Registry stays public so `azd` and CI runners can push images without a self-hosted agent or VPN. Image pulls flow outbound from the Container Apps data plane
- ✅ **Private DNS Zones**: Automatic DNS resolution for private endpoints, plus a wildcard zone for the Container Apps environment's `defaultDomain`
- ✅ **Internal Container Apps**: Backend and frontend Container Apps run with `internal: true` (no public ingress)
- 🛡️ **Optional WAF entry point**: `deployAppGateway = true` adds an Application Gateway WAF_v2 (OWASP 3.2, Prevention mode) in its own subnet, terminating public HTTP and forwarding HTTPS to the frontend's internal FQDN via the private DNS zone


## Important considerations when restricting Azure Container Registry network access

If your container registry restricts access to private endpoints, selected subnets, or IP addresses, some functionality might be unavailable or require more configuration.

When you disable public network access to a registry, certain trusted services, including Microsoft Defender for Cloud, can access the registry only if you enable a network setting to bypass the network rules.

Once you disable the public network access, instances of certain Azure services, including Azure DevOps Services, can't access the container registry.

Private endpoints aren't currently supported with agents managed by Azure DevOps. You need to use a self-hosted agent with network line of sight to the private endpoint.

If the registry has an approved private endpoint and you disable public network access, you can't list repositories and tags outside the virtual network by using the Azure portal, Azure CLI, or other tools.

## Reference

- [Set Up Private Endpoint with Private Link for ACR – Azure Container Registry | Microsoft Learn](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-private-link)


**Connectivity Model**
| Service | Public Access | Private Endpoint | Private DNS |
|---------|---|---|---|
| Storage Account (Blob) | ❌ Disabled | ✅ Yes | ✅ privatelink.blob.azure.com |
| Cosmos DB | ❌ Disabled | ✅ Yes | ✅ privatelink.documents.azure.com |
| Document Intelligence | ❌ Disabled | ✅ Yes | ✅ privatelink.cognitiveservices.azure.com |
| Azure OpenAI | ❌ Disabled | ✅ Yes | ✅ privatelink.openai.azure.com |
| Key Vault | ❌ Disabled | ✅ Yes | ✅ privatelink.vaultcore.azure.net |
| Log Analytics + App Insights | ❌ Disabled (via AMPLS) | ✅ Yes | ✅ privatelink.monitor / .ods / .oms / .agentsvc |
| Container Registry | ✅ **Enabled (by design)** | ❌ No | N/A |
| Container Apps (Apps) | ❌ Internal only | N/A | ✅ private zone for env `defaultDomain` |
| Application Gateway (optional) | ✅ Enabled (when `deployAppGateway = true`) | N/A | N/A |

#### 📋 Infrastructure Files

The infrastructure is defined using **Bicep** (Infrastructure as Code):

```
infra/
├── main.bicep                          # Orchestrator template (modular)
├── main.bicepparam                     # Deployment parameters & configuration
├── main-containerapp.bicep             # Single-file Container App template
├── main-containerapp.parameters.json   # Container App parameters
└── modules/
    ├── network.bicep                   # VNet (single vnetAddressSpace param), 3 derived subnets, private DNS zones
    ├── key-vault.bicep                 # Key Vault with private endpoint
    ├── storage.bicep                   # Storage Account with private endpoint
    ├── cosmos.bicep                    # Cosmos DB with private endpoint
    ├── ai-services.bicep               # Azure OpenAI with private endpoint
    ├── document-intelligence.bicep     # Document Intelligence with private endpoint
    ├── container-registry.bicep        # ACR (public by design — only public component)
    ├── container-apps.bicep            # Backend & Frontend Container Apps (internal) + ACA Private DNS Zone
    ├── identity.bicep                  # Managed Identity
    ├── monitoring.bicep                # Application Insights & Log Analytics (AMPLS-private)
    ├── role-assignments.bicep          # RBAC role assignments
    ├── event-processing.bicep          # Event Grid subscriptions
    └── app-gateway.bicep               # Optional: App Gateway + WAF_v2 (deployed when deployAppGateway = true)
```

#### 🔧 Deployment Parameters

The infrastructure is parameterized but kept deliberately small — there is exactly one knob for the network and one knob for the optional WAF.

**Network configuration — one parameter** (`main.bicepparam`):

```bicep
// VNet address space (default: 10.0.0.0/16)
// The three subnets are derived automatically inside network.bicep via cidrSubnet():
//   .0.0/21   → Container Apps environment (delegated, ~2,000 IPs)
//   .8.0/24   → Private endpoints for PaaS services
//   .9.0/24   → Application Gateway (only populated when deployAppGateway = true)
param vnetAddressSpace = '10.0.0.0/16'
```

> **Why a single parameter?** Earlier versions exposed three separate prefixes (`vnetAddressSpace`, `containerAppsSubnetAddressPrefix`, `privateEndpointsSubnetAddressPrefix`) that had to stay in sync manually. Now you set the parent CIDR once and the subnets are carved out automatically — no chance of overlap or drift.

**Optional Application Gateway + WAF** (`main.bicepparam`):

```bicep
// Set to true to deploy an internet-facing Application Gateway (WAF_v2, OWASP 3.2,
// Prevention mode) in front of the internal frontend container app.
// Leave false for a fully-private deployment reachable only via VPN/Bastion/Front Door.
param deployAppGateway = false
```

When `deployAppGateway = true`, the template provisions:
- **WAF Policy**: OWASP 3.2 managed rules, Prevention mode, request-body inspection on
- **Public IP**: Standard SKU, static allocation, with a DNS label `agw-<resourceToken>`
- **Application Gateway**: `WAF_v2` SKU, autoscale 1–3 instances, in the dedicated `snet-app-gateway` subnet
- **Backend pool**: Points at the frontend container app's internal FQDN; HTTPS:443 backend settings use `pickHostNameFromBackendAddress: true` so SNI and the `Host` header match the ACA certificate
- **Outputs**: `APP_GATEWAY_PUBLIC_IP`, `APP_GATEWAY_FQDN`, `APP_GATEWAY_URL` (empty strings when the toggle is off)

**Subscription configuration**:

```bicep
// Subscription ID (defaults to current Azure context — only override for cross-subscription deployments)
// param subscriptionId = subscription().subscriptionId
```

**Example: Deploy to a different IP space**:

```bicep
// Override defaults for your organization's address plan.
// Subnets are still derived automatically — no other params to change.
param vnetAddressSpace = '192.168.0.0/16'
```

**Example: Public WAF in front of the frontend**:

```bicep
param vnetAddressSpace = '10.0.0.0/16'
param deployAppGateway   = true
```

After `azd up`, retrieve the public URL:

```bash
azd env get-value APP_GATEWAY_URL
# → http://agw-<token>.<region>.cloudapp.azure.com
```

#### 🚀 Deploy with Private-Only Infrastructure

```bash


# 1. Deploy with private-only infrastructure
azd up

# 2. Verify all services are private-only
# - Check Azure Portal: All services should have "Public network access: Disabled"
# - Verify private endpoints exist for all services
# - Confirm containers apps are internal (no public FQDN)
```

#### 🔍 Verify Private-Only Setup

```bash
# Check that backend API is NOT publicly accessible
curl $(azd env get-value BACKEND_URL)  
# Expected: Connection timeout (service is internal-only)

# Verify storage account has no public access
az storage account show \
  --name $(azd env get-value STORAGE_ACCOUNT_NAME) \
  --query properties.publicNetworkAccess

# ACR is intentionally public (the only public component) so azd / CI can push images.
# Confirm public access is Enabled — this is the expected state, not a misconfiguration.
az acr show \
  --name $(az acr list --query '[0].name' -o tsv) \
  --query publicNetworkAccess
# Expected: "Enabled"

# (Optional) When deployAppGateway = true, hit the public WAF endpoint:
azd env get-value APP_GATEWAY_URL
# → http://agw-<token>.<region>.cloudapp.azure.com
```

---

### �📊 Dataset Management

ARGUS uses **datasets** to define how different types of documents should be processed. A dataset contains:
- **Model Prompt**: Instructions telling the AI how to extract data from documents
- **Output Schema**: The target structure for extracted data (can be empty to let AI determine the structure)
- **Processing Options**: Settings for OCR, image analysis, summarization, and evaluation

**When to create custom datasets**: Create a new dataset when you have a specific document type that requires different extraction logic than the built-in datasets (e.g., contracts, medical reports, financial statements).

<details>
<summary><b>🗂️ Built-in Datasets</b></summary>

- **`default-dataset/`**: Invoices, receipts, general business documents
- **`medical-dataset/`**: Medical forms, prescriptions, healthcare documents

</details>

<details>
<summary><b>🔧 Create Custom Datasets</b></summary>

Datasets are managed through the web frontend interface (deployed automatically with azd):

1. **Access the frontend** (URL provided after azd deployment)
2. **Navigate to the Process Files tab**
3. **Scroll to "Add New Dataset" section**
4. **Configure your dataset**:
   - Enter dataset name (e.g., "legal-contracts")
   - Define model prompt with extraction instructions
   - Specify output schema (JSON format) or leave empty
   - Set processing options (OCR, images, evaluation)
5. **Click "Add New Dataset"** - it's saved directly to Cosmos DB

</details>

---

### � OCR Provider Configuration

ARGUS supports **two OCR providers** for document text extraction:

- **Azure Document Intelligence** (Default): Microsoft's enterprise OCR service with advanced layout understanding
- **Mistral Document AI**: Mistral's document processing service with markdown-optimized output

<details>
<summary><b>🔧 Configure OCR Provider</b></summary>

**Via Frontend (Recommended)**:
1. Navigate to **Settings** tab in the web interface
2. Select **OCR Provider** section
3. Choose your provider:
   - **Azure**: Uses Azure Document Intelligence (automatically configured during deployment)
   - **Mistral**: Requires additional configuration (endpoint, API key, model name)
4. For Mistral, enter:
   - **Mistral Endpoint**: Your Mistral Document AI API endpoint URL
   - **Mistral API Key**: Your Mistral API authentication key
   - **Mistral Model**: Model name (default: `mistral-document-ai-2505`)
5. Click **"Update OCR Provider"** to apply changes

**Via Environment Variables**:
Set the following environment variables in your deployment:

```bash
# Choose OCR provider
OCR_PROVIDER=mistral  # or "azure" (default)

# Mistral-specific configuration (only needed if OCR_PROVIDER=mistral)
MISTRAL_DOC_AI_ENDPOINT=https://your-endpoint.services.ai.azure.com/providers/mistral/azure/ocr
MISTRAL_DOC_AI_KEY=your-mistral-api-key
MISTRAL_DOC_AI_MODEL=mistral-document-ai-2505
```

**Update via Azure Portal**:
1. Navigate to Azure Portal → Container Apps → Your Backend App
2. Go to **Settings** → **Environment variables**
3. Add/update the variables listed above
4. **Restart** the container app

**Update via Azure CLI**:
```bash
# Switch to Mistral
az containerapp update \
  --name <your-backend-app-name> \
  --resource-group <your-resource-group> \
  --set-env-vars \
    OCR_PROVIDER="mistral" \
    MISTRAL_DOC_AI_ENDPOINT="https://your-endpoint.../ocr" \
    MISTRAL_DOC_AI_KEY="your-api-key" \
    MISTRAL_DOC_AI_MODEL="mistral-document-ai-2505"

# Switch back to Azure
az containerapp update \
  --name <your-backend-app-name> \
  --resource-group <your-resource-group> \
  --set-env-vars OCR_PROVIDER="azure"
```

**Note**: OCR provider selection is configured at the solution level and applies to all document processing operations.

</details>

---

The Streamlit frontend is **automatically deployed** with `azd up` and provides a user-friendly interface for document management.

> **Note**: ARGUS ships with two frontends: a modern **Next.js** interface (default, deployed as `ca-frontend`) and a legacy **Streamlit** interface. The Next.js frontend is recommended for production use.

<div align="center">
<img src="docs/ArchitectureOverview.png" alt="ARGUS Frontend Interface" width="800"/>
</div>

### 🎯 Frontend Features

| Tab | Functionality |
|-----|---------------|
| **🧠 Process Files** | Drag-and-drop document upload with real-time processing status |
| **🔍 Explore Data** | Browse processed documents, search results, view extraction details |
| **⚙️ Settings** | Configure datasets, adjust processing parameters, manage connections |
| **📋 Instructions** | Interactive help, API documentation, and usage examples |

---

## ️ Development & Customization

### 🏗️ Project Structure Deep Dive

```
ARGUS/
├── 📋 azure.yaml                        # Azure Developer CLI configuration
├── 📄 README.md                         # Project documentation & setup guide
├── 📄 LICENSE                           # MIT license file
├── 📄 CONTRIBUTING.md                   # Contribution guidelines
├── 📄 sample-invoice.pdf                # Sample document for testing
├── 🔧 .env.template                     # Environment variables template
├── 📂 .github/                          # GitHub Actions & workflows
├── 📂 .devcontainer/                    # Development container configuration
├── 📂 .vscode/                          # VS Code settings & extensions
│
├── 📂 infra/                            # 🏗️ Azure Infrastructure as Code
│   ├── ⚙️ main.bicep                    # Orchestrator Bicep template (calls modules)
│   ├── ⚙️ main.parameters.json          # Infrastructure parameters & configuration
│   ├── ⚙️ main-containerapp.bicep       # Container App specific infrastructure
│   ├── ⚙️ main-containerapp.parameters.json # Container App parameters
│   ├── 📋 abbreviations.json            # Azure resource naming abbreviations
│   └── 📂 modules/                      # Modular Bicep components
│       ├── ⚙️ network.bicep             # VNet (single vnetAddressSpace), 3 derived subnets, private DNS zones
│       ├── ⚙️ identity.bicep            # User-assigned managed identity
│       ├── ⚙️ storage.bicep             # Storage account + private endpoint
│       ├── ⚙️ cosmos.bicep              # Cosmos DB + private endpoint
│       ├── ⚙️ ai-services.bicep         # Azure OpenAI + model deployment + PE
│       ├── ⚙️ document-intelligence.bicep # Doc Intelligence + private endpoint
│       ├── ⚙️ key-vault.bicep           # Key Vault + private endpoint
│       ├── ⚙️ container-registry.bicep  # ACR (public by design — only public component)
│       ├── ⚙️ container-apps.bicep      # CAE + backend/frontend container apps + ACA private DNS zone
│       ├── ⚙️ role-assignments.bicep    # RBAC role assignments
│       ├── ⚙️ monitoring.bicep          # Application Insights + Log Analytics (AMPLS-private)
│       ├── ⚙️ event-processing.bicep    # Event Grid subscriptions
│       └── ⚙️ app-gateway.bicep         # Optional App Gateway + WAF_v2 (deployAppGateway = true)
│
├── 📂 src/                              # 🚀 Core Application Source Code
│   ├── 📂 containerapp/                 # FastAPI Backend Service
│   │   ├── 🚀 main.py                   # FastAPI app lifecycle & configuration
│   │   ├── 🔌 api_routes.py             # HTTP endpoints & request handlers
│   │   ├── 🔧 dependencies.py           # Azure client initialization & management
│   │   ├── 📋 models.py                 # Pydantic data models & schemas
│   │   ├── ⚙️ blob_processing.py        # Document processing pipeline orchestration
│   │   ├── 🎛️ logic_app_manager.py     # Azure Logic Apps concurrency management
│   │   ├── 🐳 Dockerfile                # Container image definition
│   │   ├── 📦 requirements.txt          # Python dependencies
│   │   ├── 📄 REFACTORING_SUMMARY.md    # Architecture documentation
│   │   │
│   │   ├── 📂 ai_ocr/                   # 🧠 AI Processing Engine
│   │   │   ├── 🔍 process.py            # Main processing orchestration & workflow
│   │   │   ├── 🔗 chains.py             # LangChain integration & AI workflows
│   │   │   ├── 🤖 model.py              # Configuration models & data structures
│   │   │   ├── ⏱️ timeout.py            # Processing timeout management
│   │   │   │
│   │   │   └── 📂 azure/                # ☁️ Azure Service Integrations
│   │   │       ├── ⚙️ config.py         # Environment & configuration management
│   │   │       ├── 📄 doc_intelligence.py # Azure Document Intelligence OCR
│   │   │       ├── 🖼️ images.py         # PDF to image conversion utilities
│   │   │       └── 🤖 openai_ops.py     # Azure OpenAI API operations
│   │   │
│   │   ├── 📂 example-datasets/         # 📊 Default Dataset Configurations
│   │   ├── 📂 datasets/                 # 📁 Runtime dataset storage
│   │   └── 📂 evaluators/               # 📈 Data quality evaluation modules
│   │
│   └── 📂 evaluators/                   # 🧪 Evaluation Framework
│       ├── 📋 field_evaluator_base.py   # Abstract base class for evaluators
│       ├── 🔤 fuzz_string_evaluator.py  # Fuzzy string matching evaluation
│       ├── 🎯 cosine_similarity_string_evaluator.py # Semantic similarity evaluation
│       ├── 🎛️ custom_string_evaluator.py # Custom evaluation logic
│       ├── 📊 json_evaluator.py         # JSON structure validation
│       └── 📂 tests/                    # Unit tests for evaluators
│
├── 📂 frontend-next/                    # 🖥️ Next.js Web Interface
│   ├── 📱 src/app/                      # App Router pages and API routes
│   │   ├── 📄 page.tsx                  # Home page with document processing
│   │   ├── 📂 explore/                  # Document browsing & analysis
│   │   ├── 📂 settings/                 # Configuration management
│   │   ├── 📂 instructions/             # Help & documentation
│   │   ├── 📂 api-docs/                 # API reference documentation
│   │   ├── 📂 mcp/                      # MCP integration info
│   │   └── 📂 api/                      # Backend proxy API routes
│   ├── 📂 src/components/               # Reusable React components
│   ├── 📂 src/lib/                      # API client & utilities
│   ├── 🐳 Dockerfile                    # Frontend container definition
│   ├── 📦 package.json                  # Node.js dependencies
│   └── ⚙️ next.config.js               # Next.js configuration
│
├── 📂 frontend/                         # 🖥️ Legacy Streamlit Interface
│   ├── 📱 app.py                        # Main Streamlit application entry point
│   ├── 🔄 backend_client.py             # API client for backend communication
│   ├── 📤 process_files.py              # File upload & processing interface
│   ├── 🔍 explore_data.py               # Document browsing & analysis UI
│   ├── 💬 document_chat.py              # Interactive document Q&A interface
│   ├── 📋 instructions.py               # Help & documentation tab
│   ├── ⚙️ settings.py                   # Configuration management UI
│   ├── 🎛️ concurrency_management.py    # Performance tuning interface
│   ├── 📊 concurrency_settings.py      # Concurrency configuration utilities
│   ├── 🐳 Dockerfile                    # Frontend container definition
│   ├── 📦 requirements.txt              # Python dependencies for frontend
│   └── 📂 static/                       # Static assets (logos, images)
│       └── 🖼️ logo.png                  # ARGUS brand logo
│
├── 📂 demo/                             # 📋 Sample Datasets & Examples
│   ├── 📂 default-dataset/              # General business documents dataset
│   │   ├── 📄 system_prompt.txt         # AI extraction instructions
│   │   ├── 📊 output_schema.json        # Expected data structure
│   │   ├── 📄 ground_truth.json         # Validation reference data
│   │   └── 📄 Invoice Sample.pdf        # Sample document for testing
│   │
│   └── 📂 medical-dataset/              # Healthcare documents dataset
│       ├── 📄 system_prompt.txt         # Medical-specific extraction rules
│       ├── 📊 output_schema.json        # Medical data structure
│       └── 📄 eyes_surgery_pre_1_4.pdf  # Sample medical document
│
├── 📂 notebooks/                        # 📈 Analytics & Evaluation Tools
│   ├── 🧪 evaluator.ipynb              # Comprehensive evaluation dashboard
│   ├── 📊 output.json                  # Evaluation results & metrics
│   ├── 📦 requirements.txt              # Jupyter notebook dependencies
│   ├── 📄 README.md                     # Notebook usage instructions
│   └── 📂 outputs/                      # Historical evaluation results
│
└── 📂 docs/                             # 📚 Documentation & Assets
    └── 🖼️ ArchitectureOverview.png      # System architecture diagram
```

### 🧪 Local Development Setup

```bash
# Setup development environment
cd src/containerapp
python -m venv venv
source venv/bin/activate  # or `venv\Scripts\activate` on Windows
pip install -r requirements.txt

# Configure local environment
cp ../../.env.template .env
# Edit .env with your development credentials

# Run with hot reload
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Access API documentation
open http://localhost:8000/docs
```

### 🔧 Key Technologies & Libraries

| Category | Technologies |
|----------|-------------|
| **🚀 API Framework** | FastAPI, Uvicorn, Pydantic |
| **🧠 AI/ML** | LangChain, OpenAI SDK, Azure AI SDK |
| **☁️ Azure Services** | Azure SDK (Blob, Cosmos, Document Intelligence, Key Vault) |
| **📱 Frontend** | Next.js 15, React, Tailwind CSS, shadcn/ui |
| **📄 Document Processing** | PyMuPDF, Pillow, PyPDF2 |
| **📊 Data & Analytics** | Pandas, NumPy, Matplotlib |
| **🔒 Security** | Azure Identity, managed identities, Private Endpoints |

---

##  API Reference: Complete Documentation

### 🚀 Core Processing Endpoints

<details>
<summary><b>📄 POST /api/process-blob - Process Document from Storage</b></summary>

**Request**:
```json
{
  "blob_url": "https://storage.blob.core.windows.net/datasets/default-dataset/invoice.pdf",
  "dataset_name": "default-dataset",
  "priority": "normal",
  "webhook_url": "https://your-app.com/webhooks/argus",
  "metadata": {
    "source": "email_attachment",
    "user_id": "user123"
  }
}
```

**Response**:
```json
{
  "status": "success",
  "job_id": "job_12345",
  "extraction_results": {
    "invoice_number": "INV-2024-001",
    "total_amount": "$1,250.00",
    "confidence_score": 0.94
  },
  "processing_time": "2.3s",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

</details>

<details>
<summary><b>📤 POST /api/process-file - Direct File Upload</b></summary>

**Request** (multipart/form-data):
```
file: [PDF/Image file]
dataset_name: "default-dataset"
priority: "high"
```

**Response**:
```json
{
  "status": "success",
  "job_id": "job_12346",
  "blob_url": "https://storage.blob.core.windows.net/temp/uploaded_file.pdf",
  "extraction_results": {...},
  "processing_time": "1.8s"
}
```

</details>

<details>
<summary><b>💬 POST /api/chat - Interactive Document Q&A</b></summary>

**Request**:
```json
{
  "blob_url": "https://storage.blob.core.windows.net/datasets/contract.pdf",
  "question": "What are the payment terms and penalties for late payment?",
  "context": "focus on financial obligations",
  "temperature": 0.1
}
```

**Response**:
```json
{
  "answer": "Payment terms are Net 30 days. Late payment penalty is 1.5% per month on outstanding balance...",
  "confidence": 0.91,
  "sources": [
    {"page": 2, "section": "Payment Terms"},
    {"page": 5, "section": "Default Provisions"}
  ],
  "processing_time": "1.2s"
}
```

</details>

### ⚙️ Configuration Management

<details>
<summary><b>🔧 GET/POST /api/configuration - System Configuration</b></summary>

**GET Response**:
```json
{
  "openai_settings": {
    "endpoint": "https://your-openai.openai.azure.com/",
    "model": "gpt-35-turbo",
    "temperature": 0.1,
    "max_tokens": 4000
  },
  "processing_settings": {
    "max_concurrent_jobs": 5,
    "timeout_seconds": 300,
    "retry_attempts": 3
  },
  "datasets": ["default-dataset", "medical-dataset", "financial-reports"]
}
```

**POST Request**:
```json
{
  "openai_settings": {
    "temperature": 0.05,
    "max_tokens": 6000
  },
  "processing_settings": {
    "max_concurrent_jobs": 8
  }
}
```

</details>

### 📊 Monitoring & Analytics

<details>
<summary><b>📈 GET /api/metrics - Performance Metrics</b></summary>

**Response**:
```json
{
  "period": "last_24h",
  "summary": {
    "total_documents": 1247,
    "successful_extractions": 1198,
    "failed_extractions": 49,
    "success_rate": 96.1,
    "avg_processing_time": "2.3s"
  },
  "performance": {
    "p50_processing_time": "1.8s",
    "p95_processing_time": "4.2s",
    "p99_processing_time": "8.1s"
  },
  "errors": {
    "ocr_failures": 12,
    "ai_timeouts": 8,
    "storage_issues": 3,
    "other": 26
  }
}
```

</details>

---

##  Contributing & Community

### 🎯 How to Contribute

We welcome contributions! Here's how to get started:

1. **🍴 Fork & Clone**:
   ```bash
   git clone https://github.com/your-username/ARGUS.git
   cd ARGUS
   ```

2. **🌿 Create Feature Branch**:
   ```bash
   git checkout -b feature/amazing-improvement
   ```

3. **🧪 Develop & Test**:
   ```bash
   # Setup development environment
   ./scripts/setup-dev.sh
   
   # Run tests
   pytest tests/ -v
   
   # Lint code
   black src/ && flake8 src/
   ```

4. **📝 Document Changes**:
   ```bash
   # Update documentation
   # Add examples to README
   # Update API documentation
   ```

5. **🚀 Submit PR**:
   ```bash
   git commit -m "feat: add amazing improvement"
   git push origin feature/amazing-improvement
   # Create pull request on GitHub
   ```

### 📋 Contribution Guidelines

| Type | Guidelines |
|------|------------|
| **🐛 Bug Fixes** | Include reproduction steps, expected vs actual behavior |
| **✨ New Features** | Discuss in issues first, include tests and documentation |
| **📚 Documentation** | Clear examples, practical use cases, proper formatting |
| **🔧 Performance** | Benchmark results, before/after comparisons |

### 🏆 Recognition

Contributors will be recognized in:
- 📝 Release notes for significant contributions
- 🌟 Contributors section (with permission)
- 💬 Community showcase for innovative use cases

---

## 📞 Support & Resources

### 💬 Getting Help

| Resource | Description | Link |
|----------|-------------|------|
| **📚 Documentation** | Complete setup and usage guides | [docs/](docs/) |
| **�🐛 Issue Tracker** | Bug reports and feature requests | [GitHub Issues](https://github.com/Azure-Samples/ARGUS/issues) |
| **💡 Discussions** | Community Q&A and ideas | [GitHub Discussions](https://github.com/Azure-Samples/ARGUS/discussions) |
| **📧 Team Contact** | Direct contact for enterprise needs | See team section below |

### 🔗 Additional Resources

- **📖 Azure Document Intelligence**: [Official Documentation](https://docs.microsoft.com/azure/applied-ai-services/form-recognizer/)
- **🤖 Azure OpenAI**: [Service Documentation](https://docs.microsoft.com/azure/cognitive-services/openai/)
- **⚡ FastAPI**: [Framework Documentation](https://fastapi.tiangolo.com/)
- **🐍 LangChain**: [Integration Guides](https://python.langchain.com/)

---

## 👥 Team

- **Alberto Gallo**
- **Petteri Johansson**
- **Christin Pohl**
- **Konstantinos Mavrodis**

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

## 🚀 Ready to Transform Your Document Processing?

**Deploy ARGUS in minutes and start extracting intelligence from your documents today!**

```bash
git clone https://github.com/Azure-Samples/ARGUS.git && cd ARGUS && azd up
```

<br>

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template)
[![Open in Dev Container](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/Azure-Samples/ARGUS)

<br>

**⭐ Star this repo if ARGUS helps your document processing needs!**

</div>
