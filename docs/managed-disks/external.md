## Define Managed Disks
Define the `managed_disks` variable to create managed disks independently from any particular instance. These disks can be created without being attached to an instance. They can then be attached and detached as needed.
``` py linenums="1"
managed_disks = {
    test_disk_1 = {
        resource_group = "sharedinfra"
        zone = "2"
        storage_account_type = "Premium_LRS"
        disk_size_gb = "64"
    }
    test_disk_2 = {
        resource_group = "sharedinfra"
        zone = "2"
        storage_account_type = "Premium_LRS"
        disk_size_gb = "64"
    }
}
```
## Attach Managed Disks to VMs
Use the `external_disk` attribute to attach one of the external managed disks to a VM. The managed disk must be in the same zone as the VM to be attached.
``` py linenums="1" hl_lines="21-24"
hsw = {
    names = [
        "HSW3TEST"
    ]
    size = "Standard_D2s_v4"
    virtual_machine_scale_set = "testvmss"
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
            storage_account_type = "Premium_LRS"
            disk_size_gb = "64"
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