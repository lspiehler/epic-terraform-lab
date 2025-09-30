## Define Managed Disks
Define the `name` and `resource_group` attributes to reference an existing, manually created disk. The `existing` attribute must be set to `true` to indicate that the disk is not managed by Terraform.
``` py linenums="1" hl_lines="8-12"
managed_disks = {
    test_disk_1 = {
        resource_group = "sharedinfra"
        zone = "2"
        storage_account_type = "Premium_LRS"
        disk_size_gb = "64"
    }
    test_disk_2  {
        name = "Lyas-Test"
        resource_group = "hsw"
        existing = true
    }
}
```
## Attach Manually Created Disks to VMs
Use the `external_disk` attribute to attach one of the manually created disks to a VM. The disk must be in the same zone as the instance to be attached.
``` py linenums="1" hl_lines="20-23"
hsw_z2 = {
    names = [
        "HSW3TEST"
    ]
    size = "Standard_D2s_v4"
    zone = "2"
    resource_group = "hsw"
    nics = {
        primary = {
            ip_configuration = [{
                subnet = "main.hsw"
            }]
        }
    }
    disks = {
        disk1 = {
            lun = "0"
            external_disk = "test_disk_1"
        }
        disk2 = {
            lun = "1"
            external_disk = "test_disk_2"
        }
    }
}
```
The commands below can be used to get a list of managed disks and the keys that can be used to reference them.
``` py linenums="1"
terraform -chdir=src console -plan -var-file="../environments/yourenv.tfvars"
module.managed_disk.managed_disk
```