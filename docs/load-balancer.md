See below for an example of a load balancer configuration. Tags are used to identify the resources that will be added to the load balancer's backend address pool.
## Load Balancer Variables Example
``` py linenums="1"
load_balancer = {
    PKIaaS-LB = {
        resource_group = "PKIaaS_Ansible"

        frontend_ip_configuration = {
            pkiaas_fe_ip = {
                public_ip_address = "pkiaas_public_ip"
            }
        }

        rules = {
            route-443-8443 = {
                frontend_port = 443
                backend_port = 8443
                probe = "HTTP"
                frontend_ip_configuration_name = "pkiaas_fe_ip"
                backend_address_pools = ["pkiaas-backend"]
            },
            route-4433-4433 = {
                frontend_port = 4433
                backend_port = 4433
                probe = "HTTP"
                frontend_ip_configuration_name = "pkiaas_fe_ip"
                backend_address_pools = ["pkiaas-backend"]
            },
            route-80-8080 = {
                frontend_port = 80
                backend_port = 8080
                probe = "HTTP"
                frontend_ip_configuration_name = "pkiaas_fe_ip"
                backend_address_pools = ["pkiaas-backend"]
            },
            route-dns = {
                frontend_port = 53
                backend_port = 55
                protocol = "Udp"
                probe = "HTTP"
                frontend_ip_configuration_name = "pkiaas_fe_ip"
                backend_address_pools = ["pkiaas-backend"]
            }
        }

        probes = {
            HTTP = {
                protocol = "Https"
                port = 8443
                request_path = "/"
            },
            SSH = {
                Protocol = "Tcp"
                port = 22
            }
        }

        nat_rules = {
            ssh = {
                frontend_port_start = 22
                frontend_port_end = 22
                backend_port = 22
                backend_address_pool = "pkiaasdockera"
                frontend_ip_configuration_name = "pkiaas_fe_ip"
            },
            prometheus_a = {
                frontend_port_start = 9100
                frontend_port_end = 9100
                backend_port = 9100
                backend_address_pool = "pkiaasdockera"
                frontend_ip_configuration_name = "pkiaas_fe_ip"
            },
            prometheus_b = {
                frontend_port_start = 9101
                frontend_port_end = 9101
                backend_port = 9100
                backend_address_pool = "pkiaasdockerb"
                frontend_ip_configuration_name = "pkiaas_fe_ip"
            }
        }

        outbound_rules = {
            internet-only = {
                backend_address_pool = "internet-only"
                frontend_ip_configuration = [
                    {
                        name = "pkiaas_fe_ip"
                    }
                ]
            }
        }

        backend_address_pool = {
            internet-only = {
                target = {
                    vm_tag = {
                        key = "internet-only-backend"
                        value = "true"
                    }
                }
            },
            pkiaas-backend = {
                target = {
                    vm_tag = {
                        key = "pkiaas-backend"
                        value = "true"
                    }
                }
            },
            pkiaasdockera = {
                target = {
                    vm_tag = {
                        key = "pkiaasdockera-backend"
                        value = "true"
                    }
                }
            },
            pkiaasdockerb = {
                target = {
                    vm_tag = {
                        key = "pkiaasdockerb-backend"
                        value = "true"
                    }
                }
            }
        }
    }
}
```
## VM Tags Example
``` py linenums="1"
linux_vms = {
    pkiaasdockera = {
        names = [
            "pkiaasdockera"
        ]
        size = "Standard_B1ms"
        resource_group = "PKIaaS_Ansible"
        nics = {
            primary = {
                accelerated_networking_enabled = false
                ip_configuration = [{
                    subnet = "PKIaaS.app"
                }]
            }
        }
        source_image_reference = {
            publisher = "canonical"
            offer = "ubuntu-24_04-lts"
            sku = "server"
            version = "latest"
        }
        tags = {
            internet-only-backend = "true"
            pkiaasdockera-backend = "true"
            pkiaas-backend = "true"
        }
    }
    pkiaasdockerb = {
        names = [
            "pkiaasdockera"
        ]
        size = "Standard_B1ms"
        resource_group = "PKIaaS_Ansible"
        nics = {
            primary = {
                accelerated_networking_enabled = false
                ip_configuration = [{
                    subnet = "PKIaaS.app"
                }]
            }
        }
        source_image_reference = {
            publisher = "canonical"
            offer = "ubuntu-24_04-lts"
            sku = "server"
            version = "latest"
        }
        tags = {
            internet-only-backend = "true"
            pkiaasdockerb-backend = "true"
            pkiaas-backend = "true"
        }
    }
}
```