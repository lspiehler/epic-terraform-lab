resource "azurerm_application_gateway" "application_gateway" {
  for_each = var.agws
  name = each.value.name != null ? each.value.name : "${var.name_prefixes["agw"]}${each.key}${var.name_suffixes["agw"]}"
  resource_group_name = var.resource_group[each.value.resource_group].name
  location = each.value.location != null ? each.value.location : var.location

  sku {
    name = each.value.sku.sku_name
    tier = each.value.sku.sku_tier
    capacity = each.value.sku.capacity
  }

  dynamic "gateway_ip_configuration" {
    for_each = each.value.gateway_ip_configuration
    content {
        name = gateway_ip_configuration.value.name
        subnet_id = var.subnet[gateway_ip_configuration.value.subnet].id
    }
  }

  dynamic "frontend_port" {
    for_each = each.value.frontend_port
    content {
        name = frontend_port.value.name
        port = frontend_port.value.port
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = each.value.frontend_ip_configuration
    content {
        name = frontend_ip_configuration.value.name
        subnet_id = frontend_ip_configuration.value.subnet == null ? null : var.subnet[frontend_ip_configuration.value.subnet].id
        public_ip_address_id = frontend_ip_configuration.value.public_ip_address == null ? null : var.public_ips[frontend_ip_configuration.value.public_ip_address].id
        private_ip_address = frontend_ip_configuration.value.private_ip_address
        private_ip_address_allocation = frontend_ip_configuration.value.private_ip_address_allocation
    }
  }

  dynamic "backend_address_pool" {
    for_each = each.value.backend_address_pool
    content {
        name = backend_address_pool.value.name
        fqdns = backend_address_pool.value.fqdns == null ? null : backend_address_pool.value.fqdns
        //ip_addresses = backend_address_pool.value.vms == null ? null : local.ips[backend_address_pool.value.vms.vm_type][backend_address_pool.value.vms.vm_key]["nics"]["ips"]
        ip_addresses = length(local.agw_backend_ips) > 0 ? local.agw_backend_ips[each.key][backend_address_pool.key] : null
    }
  }

  /*dynamic "auto_backend_address_pool" {
    for_each = local.auto_backend_address_pool
    content {
        name = auto_backend_address_pool.value.name
        fqdns = auto_backend_address_pool.value.fqdns == null ? null : auto_backend_address_pool.value.fqdns
        //ip_addresses = auto_backend_address_pool.value.vms == null ? null : local.ips[auto_backend_address_pool.value.vms.vm_type][auto_backend_address_pool.value.vms.vm_key]["nics"]["ips"]
        ip_addresses = length(local.agw_backend_ips) > 0 ? local.agw_backend_ips[each.key][auto_backend_address_pool.key] : null
    }
  }*/

  dynamic "backend_http_settings" {
    for_each = each.value.backend_http_settings
    content {
        name = backend_http_settings.value.name
        port = backend_http_settings.value.port
        host_name = backend_http_settings.value.host_name
        cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
        affinity_cookie_name = backend_http_settings.value.affinity_cookie_name
        protocol = backend_http_settings.value.protocol
        request_timeout = backend_http_settings.value.request_timeout
        probe_name = backend_http_settings.value.probe_name
        path = backend_http_settings.value.path
        trusted_root_certificate_names = backend_http_settings.value.trusted_root_certificate_names
        dynamic "connection_draining" {
          for_each = backend_http_settings.value.connection_draining == null ? [] : [1]
          content {
            enabled = backend_http_settings.value.connection_draining.enabled
            drain_timeout_sec = backend_http_settings.value.connection_draining.drain_timeout_sec
          }
        }
    }
  }

  dynamic "ssl_profile" {
    for_each = each.value.ssl_profile
    content {
        name = ssl_profile.value.name
    }
  }

  dynamic "http_listener" {
    for_each = each.value.http_listener
    content {
        name = http_listener.value.name
        frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
        frontend_port_name = http_listener.value.frontend_port_name
        protocol = http_listener.value.protocol
        ssl_certificate_name = http_listener.value.ssl_certificate_name
        host_names = http_listener.value.host_names
        host_name = http_listener.value.host_name
    }
  }

  dynamic "probe" {
    for_each = each.value.probe
    content {
        name = probe.value.name
        protocol = probe.value.protocol
        host = probe.value.host
        interval = probe.value.interval
        path = probe.value.path
        port = probe.value.port
        timeout = probe.value.timeout
        unhealthy_threshold = probe.value.unhealthy_threshold
        pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
        dynamic "match" {
          for_each = probe.value.match == null ? [] : [1]
          content {
            body = probe.value.match.body
            status_code = probe.value.match.status_code
          }
        }
    }
  }

  dynamic "ssl_certificate" {
    for_each = each.value.ssl_certificate
    content {
        name = ssl_certificate.value.name
        data = ssl_certificate.value.key_vault_secret_id == null ? filebase64(ssl_certificate.value.data) : null
        password = ssl_certificate.value.key_vault_secret_id == null ? ssl_certificate.value.password : null
        key_vault_secret_id = ssl_certificate.value.key_vault_secret_id
    }
  }

  dynamic "trusted_root_certificate" {
    for_each = each.value.trusted_root_certificate
    content {
        name = trusted_root_certificate.value.name
        data = trusted_root_certificate.value.data != null ? file(trusted_root_certificate.value.data) : null
    }
  }

  dynamic "request_routing_rule" {
    for_each = each.value.request_routing_rule
    content {
        name = request_routing_rule.value.name
        http_listener_name = request_routing_rule.value.http_listener_name
        rule_type = request_routing_rule.value.rule_type
        priority = request_routing_rule.value.priority
        backend_address_pool_name = request_routing_rule.value.backend_address_pool_name
        backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
        redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
    }
  }

  dynamic "redirect_configuration" {
    for_each = each.value.redirect_configuration
    content {
        name = redirect_configuration.value.name
        redirect_type = redirect_configuration.value.redirect_type
        include_path = redirect_configuration.value.include_path
        include_query_string = redirect_configuration.value.include_query_string
        target_url = redirect_configuration.value.target_url
        target_listener_name = redirect_configuration.value.target_listener_name
    }
  }

  tags = merge(var.var_default_tags, each.value.tags)

  lifecycle {
    ignore_changes = [
      ssl_certificate, identity, global
    ]
  }
}