## NAT Gateway Use Case
> After September 30, 2025, new virtual networks will default to requiring explicit outbound connectivity methods instead of having a fallback to default outbound access connectivity.  All virtual machines that require public endpoint access will need to use explicit outbound connectivity methods such as Azure NAT Gateway, Azure Load Balancer outbound rules, or a directly attached Azure public IP address. "

Due to [this announcement](https://azure.microsoft.com/en-us/updates?id=default-outbound-access-for-vms-in-azure-will-be-retired-transition-to-a-new-method-of-internet-access), our code has been updated to support NAT gateways for outbound internet access. A `default_outbound_access_enabled` attribute has been added to the `subnets` variable, which is set to `false` by default. This requires that outbound internet access be provided by a NAT gateway or [other method](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/default-outbound-access#how-and-when-default-outbound-access-is-provided).

If the customer has an ALZ that provides outbound access, User Defined Routes (UDRs) should be used to route outbound traffic to the appropriate destination within the ALZ, otherwise, a NAT gateway should be used.

## Create Public IPs Example
A NAT gateway requires one or more public IP addresses. Below is an example of how to create the public IPs that will be used by the NAT gateway(s). The public IPs must be created in the same resource group as the NAT gateway it will be attached to.
``` py linenums="1" hl_lines="7-26"
public_ips = {
    bastion = {
        resource_group = "network"
        allocation_method = "Static"
        sku = "Standard"
    }
    main1 = {
        resource_group = "network"
        allocation_method = "Static"
        sku = "Standard"
    }
    main2 = {
        resource_group = "network"
        allocation_method = "Static"
        sku = "Standard"
    }
    dmz = {
        resource_group = "network"
        allocation_method = "Static"
        sku = "Standard"
    }
    sharedinfra = {
        resource_group = "network"
        allocation_method = "Static"
        sku = "Standard"
    }
}
```

## NAT Gateway Variables Example
See below for an example of a NAT gateway configuration. The same NAT gateway cannot be used on more than one virtual network, so one must be created for each.
``` py linenums="1"
nat_gateway = {
    main = {
        resource_group = "network"
        public_ips = ["main1", "main2"]
    }
    dmz = {
        resource_group = "network"
        public_ips = ["dmz"]
    }
    sharedinfra = {
        resource_group = "network"
        public_ips = ["sharedinfra"]
    }
}
```
## NAT Gateway Attachments Example
Attachments to the NAT gateway are made in the `subnets` block of the `networks` variable, as shown in the example below.

**Note:** A NAT gateway should not be attached to dedicated subnets for services like Bastion and the Azure Application Gateway.
``` py linenums="1" hl_lines="10 16 21 26 32 44 56"
networks = {
    "main" = {
        resource_group = "network"
        peerings = ["sharedinfra", "dmz"]
        address_space = ["10.134.52.0/24"]
        subnets = {
            vda = {
                network_security_group = "vda"
                address_prefixes = ["10.134.52.0/28"]
                nat_gateway = "main"
            }                
            odb = {
                network_security_group = "odb"
                address_prefixes = ["10.134.52.16/28"]
                service_endpoints = ["Microsoft.Storage"]
                nat_gateway = "main"
            }
            cogito = {
                network_security_group = "cogito"
                address_prefixes = ["10.134.52.32/28"]
                nat_gateway = "main"
            }
            hsw = {
                network_security_group = "hsw"
                address_prefixes = ["10.134.52.48/28"]
                nat_gateway = "main"
            }
            wss = {
                network_security_group = "wss"
                address_prefixes = ["10.134.52.64/26"]
                service_endpoints = ["Microsoft.Storage"]
                nat_gateway = "main"
            }
        }
    }
    "dmz" = {
        resource_group = "network"
        peerings = ["sharedinfra", "main"]
        address_space = ["10.134.53.0/24"]
        subnets = {
            dmz = {
                network_security_group = "dmz"
                address_prefixes = ["10.134.53.0/28"]
                nat_gateway = "dmz"
            }
        }
    }
    "sharedinfra" = {
        resource_group = "network"
        peerings = ["main", "dmz"]
        address_space = ["10.134.56.0/22"]
        subnets = {
            sharedinfra = {
                network_security_group = "sharedinfra"
                address_prefixes = ["10.134.56.0/28"]
                nat_gateway = "sharedinfra"
            }
            bastion = {
                name = "AzureBastionSubnet"
                network_security_group = "bastion"
                address_prefixes = ["10.134.57.0/26"]
            }
            agw = {
                network_security_group = "agw"
                address_prefixes = ["10.134.58.0/24"]
            }
        }
    }
}
```