variable "agws"{
    type = map(object({
        name = optional(string)
        resource_group = string
        location = optional(string, null)
        /*auto_configure_apps = optional(map(object({
            internal_host = string
        })))*/
        sku = optional(object({
            sku_name = optional(string, "Standard_v2")
            sku_tier = optional(string, "Standard_v2")
            capacity = optional(number, 2)
        }), {})
        ssl_certificate = optional(list(object({
            name = optional(string, "default_listener")
            data = optional(string, "../certs/default_listener.pfx")
            password = optional(string, "31V5G0vl5Nhy")
            key_vault_secret_id = optional(string)
        })))
        trusted_root_certificate = optional(list(object({
            name = optional(string, "default_root")
            data = optional(string, "../certs/default_root.cer")
        })))
        ssl_policy = optional(list(object({
            policy_name = string
            policy_type = optional(string, "Predefined")
            disabled_protocols = optional(string)
            cipher_suites = optional(string)
            min_protocol_version = optional(string)
        })))
        ssl_profile = optional(list(object({
            name = string
        })), [])
        gateway_ip_configuration = list(object({
            name = optional(string, "appGwIpConfig")
            subnet = string
        }))
        frontend_port = optional(list(object({
            name = string
            port = number
        })),[
            {
                name = "port_80"
                port = 80
            },
            {
                name = "port_443"
                port = 443
            }
        ])
        frontend_ip_configuration = optional(list(object({
            name = optional(string, "appGwPrivateFrontendIp")
            subnet = optional(string)
            public_ip_address = optional(string)
            private_ip_address = optional(string)
            private_ip_address_allocation = optional(string)
        })))
        backend_address_pool = optional(list(object({
            name = string
            fqdns = optional(list(string))
            //ip_addresses = optional(list(string))
            target = optional(object({
                vm_tag = object({
                    key = string
                    value = string
                })
            }))
        })))
        backend_http_settings = optional(list(object({
            name = string
            cookie_based_affinity = optional(string, "Disabled")
            affinity_cookie_name = optional(string)
            path = optional(string)
            port = optional(number, 443)
            protocol = optional(string, "Https")
            host_name = optional(string)
            request_timeout = optional(number, 60)
            probe_name = optional(string, "probe_https")
            trusted_root_certificate_names = optional(list(string), ["default_root"])
            connection_draining = optional(object({
                enabled = optional(bool, true)
                drain_timeout_sec = optional(number, 3600)
            }))
        })))
        http_listener = optional(list(object({
            name = string
            frontend_ip_configuration_name = optional(string, "appGwPrivateFrontendIp")
            frontend_port_name = optional(string, "port_80")
            protocol = string
            ssl_certificate_name = optional(string, "default_listener")
            ssl_profile_name = optional(string)
            firewall_policy_id = optional(string)
            host_names = optional(list(string))
            host_name = optional(string)
            require_sni = optional(bool)
        })))
        redirect_configuration = optional(list(object({
            name = string
            redirect_type = optional(string, "Permanent")
            include_path = optional(bool, true)
            include_query_string = optional(bool, true)
            target_url = optional(string)
            target_listener_name = optional(string)
        })))
        request_routing_rule = optional(list(object({
            name = string
            priority = number
            rule_type = string
            http_listener_name = string
            redirect_configuration_name = optional(string)
            backend_address_pool_name = optional(string)
            backend_http_settings_name = optional(string)
        })))
        probe = optional(list(object({
            name = optional(string, "probe_https")
            protocol = optional(string, "Https")
            host = optional(string)
            pick_host_name_from_backend_http_settings = optional(bool, true)
            interval = optional(number, 30)
            path = optional(string, "/")
            port = optional(number, 443)
            timeout = optional(number, 30)
            unhealthy_threshold = optional(number, 3)
            match = optional(object({
                body = optional(string)
                status_code = optional(list(string), ["200-399"])
            }), {})
        })))
        tags = optional(map(string), {})
    }))
    default = {}
}