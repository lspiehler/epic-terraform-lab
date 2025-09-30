See below for an example of an application gateway configuration. Tags are used to identify the resources that will be added to the application gateway's backend address pool.
## Application Gateway Variables Example
``` py linenums="1"
agws = {
    myagw = {
        name = "agw-epic-eus2-np"
        resource_group = "network"
        gateway_ip_configuration = [{
            name = "agw-gic-epic-eus2-np"
            subnet = "sharedinfra.agw"
        }]
        frontend_ip_configuration = [{
            name = "agw-gic-epic-eus2-np"
            public_ip_address = "agw"
        }]
        probe = [{}]
        ssl_certificate = [{}]
        trusted_root_certificate = [{}]
        backend_address_pool = [
            {
                name = "backend_address_hsw"
                target = {
                    vm_tag = {
                        key = "backend_address_pool"
                        value = "hsw"
                    }
                }
            },
            {
                name = "backend_address_slic"
                target = {
                    vm_tag = {
                        key = "backend_address_pool"
                        value = "slic"
                    }
                }
            },
            {
                name = "backend_address_wbs"
                target = {
                    vm_tag = {
                        key = "backend_address_pool"
                        value = "wbs"
                    }
                }
            },
            {
                name = "backend_address_eds"
                target = {
                    vm_tag = {
                        key = "backend_address_pool"
                        value = "eds"
                    }
                }
            },
            {
                name = "backend_address_erpx"
                target = {
                    vm_tag = {
                        key = "backend_address_pool"
                        value = "erpx"
                    }
                }
            },
            {
                name = "backend_address_icfg"
                target = {
                    vm_tag = {
                        key = "backend_address_pool"
                        value = "icfg"
                    }
                }
            },
            {
                name = "backend_address_rpx"
                target = {
                    vm_tag = {
                        key = "backend_address_pool"
                        value = "rpx"
                    }
                }
            },
            {
                name = "backend_address_wbs"
                target = {
                    vm_tag = {
                        key = "backend_address_pool"
                        value = "wbs"
                    }
                }
            }
        ]
        backend_http_settings = [
            {
                name = "backend_https_hsw"
                host_name = "agw.ibx.com"
                affinity_cookie_name = "hsw-affinitycookie"
                connection_draining = {}
            },
            {
                name = "backend_https_slic"
                host_name = "agw.ibx.com"
                affinity_cookie_name = "slic-affinitycookie"
                connection_draining = {}
            },
            {
                name = "backend_https_wbs"
                host_name = "agw.ibx.com"
            },
            {
                name = "backend_https_eds"
                host_name = "agw.ibx.com"
            },
            {
                name = "backend_https_erpx"
                host_name = "agw.ibx.com"
            },
            {
                name = "backend_https_icfg"
                host_name = "agw.ibx.com"
            },
            {
                name = "backend_https_rpx"
                host_name = "agw.ibx.com"
            }
        ]
        http_listener = [
            {
                name = "http_listener_hsw"
                frontend_port_name = "port_80"
                protocol = "Http"
                host_names = ["hsw.sapphirehealth.org"]
            },
            {
                name = "https_listener_hsw"
                frontend_port_name = "port_443"
                protocol = "Https"
                host_names = ["hsw.sapphirehealth.org"]
                ssl_certificate_name = "default_listener"
            },
            {
                name = "http_listener_slic"
                frontend_port_name = "port_80"
                protocol = "Http"
                host_names = ["slic.sapphirehealth.org"]
            },
            {
                name = "https_listener_slic"
                frontend_port_name = "port_443"
                protocol = "Https"
                host_names = ["slic.sapphirehealth.org"]
                ssl_certificate_name = "default_listener"
            },
            {
                name = "http_listener_wbs"
                frontend_port_name = "port_80"
                protocol = "Http"
                host_names = ["wbs.sapphirehealth.org"]
            },
            {
                name = "https_listener_wbs"
                frontend_port_name = "port_443"
                protocol = "Https"
                host_names = ["wbs.sapphirehealth.org"]
                ssl_certificate_name = "default_listener"
            },
            {
                name = "http_listener_eds"
                frontend_port_name = "port_80"
                protocol = "Http"
                host_names = ["eds.sapphirehealth.org"]
            },
            {
                name = "https_listener_eds"
                frontend_port_name = "port_443"
                protocol = "Https"
                host_names = ["eds.sapphirehealth.org"]
                ssl_certificate_name = "default_listener"
            },
            {
                name = "http_listener_erpx"
                frontend_port_name = "port_80"
                protocol = "Http"
                host_names = ["erpx.sapphirehealth.org"]
            },
            {
                name = "https_listener_erpx"
                frontend_port_name = "port_443"
                protocol = "Https"
                host_names = ["erpx.sapphirehealth.org"]
                ssl_certificate_name = "default_listener"
            },
            {
                name = "http_listener_icfg"
                frontend_port_name = "port_80"
                protocol = "Http"
                host_names = ["icfg.sapphirehealth.org"]
            },
            {
                name = "https_listener_icfg"
                frontend_port_name = "port_443"
                protocol = "Https"
                host_names = ["icfg.sapphirehealth.org"]
                ssl_certificate_name = "default_listener"
            },
            {
                name = "http_listener_rpx"
                frontend_port_name = "port_80"
                protocol = "Http"
                host_names = ["rpx.sapphirehealth.org"]
            },
            {
                name = "https_listener_rpx"
                frontend_port_name = "port_443"
                protocol = "Https"
                host_names = ["rpx.sapphirehealth.org"]
                ssl_certificate_name = "default_listener"
            }
        ]
        redirect_configuration = [
            {
                name = "redirect_80_to_443_hsw"
                target_listener_name = "https_listener_hsw"
            },
            {
                name = "redirect_80_to_443_slic"
                target_listener_name = "https_listener_slic"
            },
            {
                name = "redirect_80_to_443_wbs"
                target_listener_name = "https_listener_wbs"
            },
            {
                name = "redirect_80_to_443_eds"
                target_listener_name = "https_listener_eds"
            },
            {
                name = "redirect_80_to_443_erpx"
                target_listener_name = "https_listener_erpx"
            },
            {
                name = "redirect_80_to_443_icfg"
                target_listener_name = "https_listener_icfg"
            },
            {
                name = "redirect_80_to_443_rpx"
                target_listener_name = "https_listener_rpx"
            }
        ]
        request_routing_rule = [
            {
                name = "hsw_http"
                priority = 10
                rule_type = "Basic"
                http_listener_name = "http_listener_hsw"
                redirect_configuration_name = "redirect_80_to_443_hsw"
            },
            {
                name = "hsw_https"
                priority = 20
                rule_type = "Basic"
                http_listener_name = "https_listener_hsw"
                backend_address_pool_name = "backend_address_hsw"
                backend_http_settings_name = "backend_https_hsw"
            },
            {
                name = "slic_http"
                priority = 30
                rule_type = "Basic"
                http_listener_name = "http_listener_slic"
                redirect_configuration_name = "redirect_80_to_443_slic"
            },
            {
                name = "slic_https"
                priority = 40
                rule_type = "Basic"
                http_listener_name = "https_listener_slic"
                backend_address_pool_name = "backend_address_slic"
                backend_http_settings_name = "backend_https_slic"
            },
            {
                name = "wbs_http"
                priority = 50
                rule_type = "Basic"
                http_listener_name = "http_listener_wbs"
                redirect_configuration_name = "redirect_80_to_443_wbs"
            },
            {
                name = "wbs_https"
                priority = 60
                rule_type = "Basic"
                http_listener_name = "https_listener_wbs"
                backend_address_pool_name = "backend_address_wbs"
                backend_http_settings_name = "backend_https_wbs"
            },
            {
                name = "eds_http"
                priority = 70
                rule_type = "Basic"
                http_listener_name = "http_listener_eds"
                redirect_configuration_name = "redirect_80_to_443_eds"
            },
            {
                name = "eds_https"
                priority = 80
                rule_type = "Basic"
                http_listener_name = "https_listener_eds"
                backend_address_pool_name = "backend_address_eds"
                backend_http_settings_name = "backend_https_eds"
            },
            {
                name = "erpx_http"
                priority = 90
                rule_type = "Basic"
                http_listener_name = "http_listener_erpx"
                redirect_configuration_name = "redirect_80_to_443_erpx"
            },
            {
                name = "erpx_https"
                priority = 100
                rule_type = "Basic"
                http_listener_name = "https_listener_erpx"
                backend_address_pool_name = "backend_address_erpx"
                backend_http_settings_name = "backend_https_erpx"
            },
            {
                name = "icfg_http"
                priority = 110
                rule_type = "Basic"
                http_listener_name = "http_listener_icfg"
                redirect_configuration_name = "redirect_80_to_443_icfg"
            },
            {
                name = "icfg_https"
                priority = 120
                rule_type = "Basic"
                http_listener_name = "https_listener_icfg"
                backend_address_pool_name = "backend_address_icfg"
                backend_http_settings_name = "backend_https_icfg"
            },
            {
                name = "rpx_http"
                priority = 130
                rule_type = "Basic"
                http_listener_name = "http_listener_rpx"
                redirect_configuration_name = "redirect_80_to_443_rpx"
            },
            {
                name = "rpx_https"
                priority = 140
                rule_type = "Basic"
                http_listener_name = "https_listener_rpx"
                backend_address_pool_name = "backend_address_rpx"
                backend_http_settings_name = "backend_https_rpx"
            }
        ]
    }
}
```
## VM Tags Example
``` py linenums="1"
windows_vms = {
    hsw_z1 = {
        names = [
            "HSW1TEST",
            "HSW2TEST"
        ]
        zones = ["1"]
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
        boot_diagnostics = {
            storage_account = "diag2"
        }
        tags = {
            application = "hsw"
            backend_address_pool = "hsw"
        }
    }
    hsw_z2 = {
        ##Hyperspace Web Servers##
        names = [
            "HSW3TEST",
            "HSW4TEST"
        ]
        zones = ["2"]
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
        boot_diagnostics = {
            storage_account = "diag2"
        }
        tags = {
            application = "hsw"
            backend_address_pool = "hsw"
        }
    }
```