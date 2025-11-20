variable "windows_vms" {
    type = map(object({
        count = optional(number, 0)
        names = optional(list(string), [])
        delimeter = optional(string, "")
        index_format = optional(string, "%02s")
        zone = optional(string)
        resource_group = optional(string)
        location = optional(string, null)
        size = optional(string)
        virtual_machine_scale_set = optional(string)
        admin_username = optional(string, "azureuser")
        admin_password_secret = optional(string, "default_password")
        timezone = optional(string, "UTC")
        patch_assessment_mode = optional(string, "AutomaticByPlatform")
        #enable_autoupdate = optional(string, "")
        #patch_mode = optional(string, "")
        backupvault = optional(string, null)
        backuppolicy = optional(string, null)
        encryption_at_host_enabled=optional(bool, true)
        license_type = optional(string, null)
        disk_controller_type = optional(string, null)
        secure_boot_enabled = optional(bool, true)
        disks = optional(map(object({
            caching = optional(string, "None")
            source_resource_id = optional(string)
            name = optional(string)
            external_disk = optional(string)
            lun = string
            # network_access_policy = optional(string, "DenyAll")
            # public_network_access_enabled = optional(bool, false)
            create_option = optional(string, "Empty")
            storage_account_type = optional(string, "Premium_LRS")
            tier = optional(string, null)
            disk_size_gb = optional(string, "300")
            disk_iops_read_write = optional(string, null)
            disk_mbps_read_write = optional(string, null)
            tags = optional(map(string), {})
        })),{})
        nics = optional(map(object({
            accelerated_networking_enabled = optional(bool, true)
            ip_forwarding_enabled = optional(bool, false)
            ip_configuration = list(list(object({
                subnet = string
                primary = optional(bool, null)
                private_ip_address_allocation = optional(string, "Dynamic")
                private_ip_address = optional(string)
            })))
            tags = optional(map(string), {})
        })),{})  
        os_disk = optional(object({
            name = optional(string)
            caching = optional(string, "ReadWrite")
            storage_account_type = optional(string, "StandardSSD_LRS")
            disk_size_gb = optional(string, "128")
        }),{})
        identity = optional(object({
            type = optional(string, null)
        }))
        extension = optional(map(object({
            name = optional(string)
            publisher = optional(string, "Microsoft.Compute")
            type = optional(string, "CustomScriptExtension")
            type_handler_version = optional(string, "1.9")
            auto_upgrade_minor_version = optional(bool, true)
            settings = optional(string)
            tags = optional(map(string), {})
        })), {})
        source_image_reference = optional(object({
            publisher = optional(string, "MicrosoftWindowsServer")
            offer = optional(string, "WindowsServer")
            sku = optional(string, "2022-Datacenter")
            version = optional(string, "latest")
        }),{})
        boot_diagnostics = optional(object({
            storage_account = string
        }))
        tags = optional(map(string), {})
    }))
    default = {}
}

variable "linux_vms" {
    type = map(object({
        count = optional(number, 0)
        names = optional(list(string), [])
        delimeter = optional(string, "")
        index_format = optional(string, "%02s")
        zone = optional(string)
        resource_group = optional(string, "odb")
        location = optional(string, null)
        size = optional(string, "Standard_E16s_v5")
        virtual_machine_scale_set = optional(string)
        admin_username = optional(string, "azureuser")
        disable_password_authentication = optional(bool, true)
        encryption_at_host_enabled=optional(bool, true) 
        admin_password_secret = optional(string, "default_password")
        secure_boot_enabled = optional(bool, true)
        admin_ssh_key = optional(object({
            username = optional(string, "azureuser")
            //public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrK38e+43RJJfHSKF8qljgKg/YklsKMMRocWE77Sr48nnyqAA85Al8eH0Yc7VOV0WfizCe8QyDh7skxNmlz6Yvotdri6YZZ8riDLT5MyDjITP818ylc1zkQqEQQ5OsjGUN8oNFpsMzY9YlZIgc4JpIOGlwkhqhtzjesyFjULAcVN+tQ5GeZfB8PGrnLmpjSjyDGp5Um8Ou80amyCtz8sApWg2/medJgJJ5umXco8A0wAM5CuQOxHfact/tr3WTCh+z95MRmPxk4B5t2y9M68XG1NhqPBno9vGWnX09DSkpBuZF/dTqHvSBgcC1qEjnoodPipUuEn3tm0tJaALaAv5R"
            public_key = string
        }), null)
        patch_assessment_mode = optional(string)
        backupvault = optional(string, null)
        backuppolicy = optional(string, null)        
        nics = optional(map(object({
            accelerated_networking_enabled = optional(bool, true)
            ip_forwarding_enabled = optional(bool, false)
            ip_configuration = list(list(object({
                subnet = string
                primary = optional(bool, null)
                private_ip_address_allocation = optional(string, "Dynamic")
                private_ip_address = optional(string)
            })))
            tags = optional(map(string), {})
        })),{})
        disk_controller_type = optional(string, null)
        disks = optional(map(object({
            caching = optional(string, "None")
            source_resource_id = optional(string)
            lun = string
            name = optional(string)
            external_disk = optional(string)
            # network_access_policy = optional(string, "DenyAll")
            # public_network_access_enabled = optional(bool, false)
            create_option = optional(string, "Empty")
            storage_account_type = optional(string, "Premium_LRS")
            tier = optional(string, null)
            disk_size_gb = optional(string, "300")
            disk_iops_read_write = optional(string, null)
            disk_mbps_read_write = optional(string, null)
            tags = optional(map(string), {})
        })),{})
        os_disk = optional(object({
            name = optional(string)
            caching = optional(string, "ReadWrite")
            storage_account_type = optional(string, "Premium_LRS")
            disk_size_gb = optional(string, "128")
        }),{})
        source_image_reference = optional(object({
            publisher = optional(string, "Redhat")
            offer = optional(string, "RHEL")
            sku = optional(string, "93-gen2")
            version = optional(string, "latest")
        }),{})
        plan = optional(object({
            name = optional(string)
            publisher = optional(string)
            product = optional(string)
        }))
        identity = optional(object({
            type = optional(string, null)
        }))
        extension = optional(map(object({
            name = optional(string)
            publisher = optional(string, "Microsoft.Compute")
            type = optional(string, "CustomScript")
            type_handler_version = optional(string, "2.0")
            auto_upgrade_minor_version = optional(bool, true)
            settings = optional(string)
            tags = optional(map(string), {})
        })), {})            
        boot_diagnostics = optional(object({
            storage_account = string
        }))
        tags = optional(map(string), {})
    }))
    default = {}
}

variable "vmss" {
    type = map(object({
        name = optional(string)
        existing = optional(bool, false)
        location = optional(string)
        resource_group = string
        platform_fault_domain_count = optional(number, 1)
        encryption_at_host_enabled = optional(bool, true)
        zones = optional(list(string), ["1", "2", "3"])
        single_placement_group = optional(bool, false)
        tags = optional(map(string), {})
    }))
    default = {}
}
