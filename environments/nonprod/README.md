# define env vars
$env:TF_VAR_default_password="Loc@lPassw0rd"

# init
terraform -chdir=src init -backend-config=storage_account_name=saterraformlyas -backend-config=container_name=lab-tfstate -backend-config=key=nonprod -backend-config=resource_group_name=RG-Terraform -backend-config=subscription_id=42a3c96e-9249-422e-acbd-ea75547850fe -backend-config=tenant_id=ad46683f-d0ff-42c7-a2d0-1fdcba869d0a

# plan
terraform -chdir=src plan -var-file="../environments/nonprod/terraform.tfvars"

# apply
terraform -chdir=src apply -var-file="../environments/nonprod/terraform.tfvars"

# destroy
terraform -chdir=src destroy -var-file="../environments/nonprod/terraform.tfvars"

# Use az cli to connect to the container and test ansible
az container exec --resource-group prod-hsw-westus2-rg --name prod-ansible-westus2-containergroup --exec-command "/bin/bash"
cd ~/source/epic-ansible-lab
. .env
source ~/venv/azure/bin/activate
ansible -i inventory.azure_rm.yml -m ansible.windows.win_ping azwu2nhsw001
ansible -i inventory.azure_rm.yml -m ansible.builtin.ping ODBTST