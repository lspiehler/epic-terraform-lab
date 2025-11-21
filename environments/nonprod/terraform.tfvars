name_prefixes = {
    rg = "prod-"
    vnet = "prod-"
    subnet = "prod-"
    nsg = "prod-"
    peering = ""
    nic = "prod-"
    vm = ""
    ip = "prod-"
    disk = "prod-"
    vmss = "prod-"
    public_ip = "prod-"
    bastion = "prod-"
    storage_account = "prod"
    share = "prod-"
    management_lock = "prod-"
    extension = "prod-"
    pep = "prod-"
    vault = "prod-"
    backup_pol = "prod-epicbh-"
    lb = "prod-"
    nat_gateway = "prod-"
}

name_suffixes = {
    rg = "-westus2-rg"
    vnet = "-westus2-vnet"
    subnet = "-westus2-snet"
    nsg = "-westus2-nsg"
    peering = "-peer"
    nic = "-westus2-nic"
    vm = ""
    ip = "-westus2-ip"
    disk = "-westus2-dsk"
    vmss = "-westus2-vmss"
    public_ip = "-westus2-pip"
    bastion = "-westus2-bastion"
    storage_account = "westus2sa"
    share = "-westus2-share"
    management_lock = "-westus2-lock"
    extension = "-westus2-ext"
    pep = "-westus2-pep"
    vault = "-westus2-vault"
    backup_pol = "-westus2-backup"
    lb = "-westus2-lb"
    nat_gateway = "-westus2-natgw"
}

location = "westus2"
timezone = "Central Standard Time"
subscription_id = "42a3c96e-9249-422e-acbd-ea75547850fe" #<-- Replace with your subscription ID

default_tags = {
    environment = "nonprod"
    repo = "https://github.com/lspiehler/epic-terraform-lab.git"
    application = "epic"
}

rgs = {
    hsw = {}
}

nsgs = {
    bastion = {
        resource_group = "hsw"
        rules = {
            Bastion_Allow_Inbound_HTTPS_443_Internet = "100"
            Bastion_Allow_Inbound_HTTPS_443_GatewayManager = "150"
            Bastion_Allow_Inbound_HTTPS_443_AzureLoadBalancer = "200"
            Bastion_Allow_Inbound_Data_Plane = "250"
            Bastion_Allow_Outbound_SSH_RDP = "100"
            Bastion_Allow_Outbound_Azure_Cloud = "150"
            Bastion_Allow_Outbound_Data_Plane = "200"
            Bastion_Allow_Outbound_GetSessionInformation = "250"
        }
    }
    hsw = {
        resource_group = "hsw"
        rules = {
            HTTP_Inbound = "100"
            HTTPS_Inbound = "110"
            RDP_Inbound = "120"
            Kuiper_Inbound = "130"
            SMB_Inbound = "140"
            RDP_Inbound_Block = "150"
        }
    }
}

################################################
###################NSG Rules####################
################################################

rules = {
    Bastion_Allow_Inbound_HTTPS_443_Internet = {
        destination_port_ranges = ["443"]
    }
    Bastion_Allow_Inbound_HTTPS_443_GatewayManager = {
        destination_port_ranges = ["443"]
        source_address_prefix = "GatewayManager"
    }
    Bastion_Allow_Inbound_HTTPS_443_AzureLoadBalancer = {
        destination_port_ranges = ["443"]
        source_address_prefix = "AzureLoadBalancer"
    }
    Bastion_Allow_Inbound_Data_Plane = {
        destination_port_ranges = ["8080", "5701"]
        source_address_prefix = "VirtualNetwork"
        protocol = "*"
        destination_address_prefixes = ["VirtualNetwork"]
    }
    Bastion_Allow_Outbound_SSH_RDP = {
        destination_port_ranges = ["22", "3389"]
        direction = "Outbound"
        protocol = "*"
        destination_address_prefixes = ["VirtualNetwork"]
    }
    Bastion_Allow_Outbound_Azure_Cloud = {
        destination_port_ranges = ["443"]
        direction = "Outbound"
        destination_address_prefix = "AzureCloud"
    }
    Bastion_Allow_Outbound_Data_Plane = {
        destination_port_ranges = ["8080", "5701"]
        direction = "Outbound"
        protocol = "*"
        source_address_prefix = "VirtualNetwork"
        destination_address_prefixes = ["VirtualNetwork"]
    }
    Bastion_Allow_Outbound_GetSessionInformation = {
        destination_port_ranges = ["80"]
        direction = "Outbound"
        protocol = "*"
        destination_address_prefixes = ["Internet"]
    }
    SSH_Inbound_Block = {
        destination_port_ranges = ["22"]
        access = "Deny"
    }
    RDP_Inbound_Block = {
        destination_port_ranges = ["3389"]
        access = "Deny"
    }
    SSH_Inbound = {
        destination_port_ranges = ["22"]
        source_address_prefixes = ["10.45.0.0/16", "10.40.39.0/24", "10.40.23.0/24", "10.40.40.0/24", "10.40.36.0/24", "10.40.20.0/24", "10.40.21.0/24", "10.41.20.0/24", "10.40.7.0/24", "199.204.56.21/32"]    
        }
    RDP_Inbound = {
        destination_port_ranges = ["3389"]
        source_address_prefixes = ["10.40.45.0/24"]
    }
    RPC_Inbound = {
        destination_port_ranges = ["135"]
    }
    FTP_Inbound = {
        destination_port_ranges = ["2022"]
        source_address_prefixes = ["10.45.0.0/16", "10.40.39.0/24", "10.40.23.0/24", "10.40.40.0/24", "10.40.36.0/24", "10.40.20.0/24", "10.40.21.0/24", "10.41.20.0/24", "10.40.7.0/24", "199.204.56.21/32"]
    }
    Iris_Inbound_Tcp = {
        destination_port_ranges = ["4002"]
    }
    Iris_Inbound_Udp = {
        protocol = "Udp"
        destination_port_ranges = ["4002"]
    }
    RedAlert_Inbound = {
        destination_port_ranges = ["10443"]
    }
    ECF_Inbound = {
        destination_port_ranges = ["6010", "6011", "6012", "6013", "6014","6031","6033","6040"]
    }
    Data_Courier_Inbound = {
        destination_port_ranges = ["4073"]
    }
    ODB_Mirror_Inbound = {
        destination_port_ranges = ["4074"]
    }
    ODB_Inbound = {
        destination_port_ranges = ["33446"]
    }
    HTTP_Inbound = {
        destination_port_ranges = ["80"]
    }
    HTTPS_Inbound = {
        destination_port_ranges = ["443"]
    }
    Kuiper_Inbound = {
        destination_port_ranges = ["135","5985-5986"]
        source_address_prefixes = ["10.40.40.0/24","10.40.24.0/24","10.45.148.10/32","10.45.124.10/32","10.45.147.49/32","10.45.122.49/32"]
    }
    ICA_Inbound = {
        destination_port_ranges = ["2598"]
    }
    ICA_Audio_Inbound = {
        destination_port_ranges = ["16500-16509"]
    }
    EDT_Inbound = {
        destination_port_ranges = ["1494","2598"]
    }
    SMB_Inbound = {
        destination_port_ranges = ["445"]
    }
    WEM_Inbound = {
        destination_port_ranges = ["8286"]
    }
    SQL_Inbound = {
        destination_port_ranges = ["1433"]
    }
    HL7_Inbound = {
        destination_port_ranges = ["20078"]
    }
    Chronicles_Inbound = {
        destination_port_ranges = ["33446-33456", "10000-10010"]
        source_address_prefixes = ["10.40.37.21/32"]
    }
    Epic_VPN_ECF_Inbound = {
        destination_port_ranges = ["6000-6039"]
        source_address_prefixes = ["199.204.56.21/32"]
    }
    Epic_ICMP_Inbound = {
        protocol = "Icmp"
        source_address_prefixes = ["199.204.56.21/32"]
        destination_port_range = "*"
    }
}

networks = {
    "hsw" = {
        resource_group = "hsw"
        address_space = ["10.40.44.0/22"]
        subnets = {
            hsw = {
                network_security_group = "hsw"
                address_prefixes = ["10.40.44.0/24"]
                nat_gateway = "hsw"
            }
            bastion = {
                name = "AzureBastionSubnet"
                network_security_group = "bastion"
                address_prefixes = ["10.40.45.0/24"]
            }
        }
    }
}

storage_accounts = {
    "diag2lyas" = {
        resource_group = "hsw"
        public_network_access_enabled = true
        shared_access_key_enabled = false
    }   
}

# vmss = {
#     hsw = {
#         resource_group = "hsw"
#         zones = ["2"]
#     }
# }

windows_vms = {
    hsw = {
        ##Hyperspace Web Servers##
        names = [
            # "azwu2nhsw001",
            # "azwu2nhsw002"
        ] 
        size = "Standard_D2as_v6"
        license_type = "Windows_Server"
        # virtual_machine_scale_set = "hsw"
        zone = "2"
        resource_group = "hsw"
        nics = {
            primary = {
                ip_configuration = [
                    [{
                        subnet = "hsw.hsw"
                    }]
                ]
            }
        }
        boot_diagnostics = {
            storage_account = "diag2lyas"
        }
        tags = {
            application = "hsw"
            backend_address_pool = "hsw"
        }
        source_image_reference = {
            publisher = "MicrosoftWindowsServer"
            offer     = "WindowsServer"
            sku       = "2022-datacenter-g2"
            version   = "latest"
        }
        # extension = {
        #     "enable-winrm2" = {
        #         settings = <<SETTINGS
        #         {
        #             "commandToExecute": "winrm quickconfig -quiet && netsh advfirewall firewall set rule group=\"Windows Remote Management\" new enable=Yes && netsh advfirewall firewall set rule name=\"Windows Remote Management (HTTP-In)\" profile=public new remoteip=localsubnet,10.40.40.0/24"
        #         }
        #         SETTINGS
        #     }
        # }
    }
}

linux_vms = {
    ansible = {
        size = "Standard_D2as_v5"
        names = [
            "ansible01"
        ]
        zone = 2
        admin_ssh_key = {
            public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCSRFZYxq5DuQrTGOPOyCyMvqC0bmMF13GUyy7+lfD21XOxcxSmKax8eX5Heuo301TCgDxM+DAG7sVFOhfrqGpsYI7LcFcVJwGZZPqsfM5TnVwxtDEbOGqNdOTtKnaoE7EuO59Ug7KptvZyMzhRiMLY6b96UOONQqNwvRYlohldZeCC2zeABqyRHSjHSITdT/7wWJJ7tASy8bS+ek5I8S72clcJ0xDliSwRvIs4TscaijnlkAvjvA1mYXm4psPKSCeeGkIdT2zo9DQbfyWgubylR49vWzqtDgvUANRWLvjZpdNk6fXIMDuGWF/G500EFquXUBOBXWY+qMVofRw+lzeN"
        }
        secure_boot_enabled = false
        disable_password_authentication = false
        resource_group = "hsw"
        nics = {
            primary = {
                ip_configuration = [[{
                    subnet = "hsw.hsw"
                }]]
            }
        }
        source_image_reference = {
            publisher = "canonical"
            offer = "ubuntu-24_04-lts"
            sku = "server"
            version = "latest"
        }
        boot_diagnostics = {
            storage_account = "diag2lyas"
        }
        identity = {
            type = "SystemAssigned"
        }
    }
}

public_ips = {
    # bastion = {
    #     resource_group = "hsw"
    #     allocation_method = "Static"
    #     sku = "Standard"
    # }
    natgw = {
        resource_group = "hsw"
        allocation_method = "Static"
        sku = "Standard"
    }
}

# bastion_host = {
#     bastion = {
#         resource_group = "hsw"
#         sku = "Standard"
#         ip_configuration = {
#             subnet = "hsw.bastion"
#             public_ip_address = "bastion"
#         }
#     }
# }

nat_gateway = {
    hsw = {
        resource_group = "hsw"
        public_ips = ["natgw"]
    }
}