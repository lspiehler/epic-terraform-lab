## Install dependencies for test
```
python3 -m pip3 install --upgrade pyhcl
```

## Manually run test
```
python3 .\tests\validate-vars.py --tfvars environments\tiny\terraform.tfvars
```

## Login and choose default subscription
```
az login
az account list --output table
az account set --subscription "00000000-0000-0000-0000-000000000000"
```

## Init example with azure statefile
```
az login
###Lyas subscription
terraform -chdir=src init -backend-config=storage_account_name=hashicorpstate -backend-config=container_name=tstate -backend-config=key=clistatefile -backend-config=resource_group_name=AZ-700_LAB -backend-config=subscription_id=b8d43dab-4db9-41db-963f-ba55321418a8 -backend-config=tenant_id=ad46683f-d0ff-42c7-a2d0-1fdcba869d0a

#ODB state file
terraform -chdir=src init -backend-config=storage_account_name=hashicorpstate -backend-config=container_name=tstate -backend-config=key=odbstatefile -backend-config=resource_group_name=AZ-700_LAB -backend-config=subscription_id=b8d43dab-4db9-41db-963f-ba55321418a8 -backend-config=tenant_id=ad46683f-d0ff-42c7-a2d0-1fdcba869d0a

### Sapphire subscription
terraform -chdir=src init -backend-config=storage_account_name=sapphiretfstate -backend-config=container_name=tfstate -backend-config=key=lyas -backend-config=resource_group_name=TerraformDevOps -backend-config=subscription_id=3a390f8c-2b3d-4650-a50b-65e28639acd2 -backend-config=tenant_id=ad46683f-d0ff-42c7-a2d0-1fdcba869d0a
```

## Set default_password environment variable
```
$env:TF_VAR_default_password="Loc@lPassw0rd"
```

## Validate example
```
terraform -chdir=src validate
```

## Plan example
```
terraform -chdir=src plan -detailed-exitcode -var-file="../environments/tiny/lyas.tfvars"
```

## Apply example
```
terraform -chdir=src apply -var-file="../environments/tiny/lyas.tfvars" -auto-approve
```

## Destroy example
```
terraform -chdir=src destroy -var-file="../environments/tiny/lyas.tfvars"
```

## Debug
```
terraform -chdir=src console -plan -var-file="../environments/tiny/lyas.tfvars"
module.managed_disk.managed_disk
```

# delete resources from state example
```
terraform -chdir=src state rm module.managed_disk.azurerm_managed_disk.managed_disk[\`"insttrn\`"] module.managed_disk.azurerm_managed_disk.managed_disk[\`"plyodb\`"]
```

## Documentation

### Install mkdocs-material
```
pip3 install mkdocs-material
#make sure any packages installed with pip are added to requirements.txt for the cloudflare build
```

### Create Initial Documentation
```
python -m mkdocs new .
```

### Test Documentation Locally
```
python -m mkdocs serve -a 0.0.0.0:8000
```

### Deploy Changes to Production (UPDATED)
```
#python -m mkdocs gh-deploy
Manually deploy updates on Cloudflare
```