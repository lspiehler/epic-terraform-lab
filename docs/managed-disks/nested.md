## Define and Attach Managed Disks to VMs
Define managed disks that will be created using the `disks` attribute within the VM variable block. When the variables are configured this way, the storage will be created and attached to the VMs they are defined within.

This method of defining managed disks is required for VM variable blocks that create more than one VM. It does not support detaching the storage without deleting the volume. If the variable is undefined, the storage is detached and deleted.
``` py linenums="1" hl_lines="15-26"
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
            storage_account_type = "Premium_LRS"
            disk_size_gb = "64"
        }
    }
}
```