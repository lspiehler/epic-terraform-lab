# Getting Started
## Set Up the Development Environment

### Clone the Repo
```
git clone https://github.com/Sapphire-Health/sapphire-terraform-azure.git
```

### Set Secret Environment Variables
```
$env:TF_VAR_windows_password="Loc@lPassw0rd"
```

---
### Storage Account Backend (Local CLI Deployment)
Use the code block below in src/providers.tf when using a storage account for the state file.
```
backend "azurerm" {}
```

### Authenticate to Azure
Login to Azure
```
az login
```
List all available subscriptions
```
az account list --output table
```
Set the default subscription
```
az account set --subscription "00000000-0000-0000-0000-000000000000"
```
## Init example with azure statefile
```
terraform -chdir=src init -backend-config=storage_account_name=nameofstorageaccount -backend-config=container_name=nameofcontainer -backend-config=key=nameofcontainerkey -backend-config=resource_group_name=nameofresourcegroup -backend-config=subscription_id=00000000-0000-0000-0000-000000000000 -backend-config=tenant_id=00000000-0000-0000-0000-000000000000 
```