resource "azurerm_lb" "lb" {
  for_each = {
    for load_balancer in local.load_balancers : "${load_balancer.key}" => load_balancer
  }
  name = each.value.name
  resource_group_name = each.value.resource_group_name
  location = each.value.location

  dynamic "frontend_ip_configuration" {
    for_each = each.value.frontend_ip_configuration
    content {
        name = frontend_ip_configuration.value.name != null ? frontend_ip_configuration.value.name : frontend_ip_configuration.key
        public_ip_address_id = frontend_ip_configuration.value.public_ip_address != null ? var.public_ips[frontend_ip_configuration.value.public_ip_address].id : null
        subnet_id = frontend_ip_configuration.value.subnet != null ? var.subnet[frontend_ip_configuration.value.subnet].id : null
        private_ip_address = frontend_ip_configuration.value.private_ip_address != null ? frontend_ip_configuration.value.private_ip_address : null
        private_ip_address_allocation = frontend_ip_configuration.value.private_ip_address_allocation != null ? frontend_ip_configuration.value.private_ip_address_allocation : null
        private_ip_address_version = frontend_ip_configuration.value.private_ip_address_version != null ? frontend_ip_configuration.value.private_ip_address_version : null
    }
  }

  tags = each.value.tags != null ? each.value.tags : each.value.tags
}

resource "azurerm_lb_backend_address_pool" "backend_address_pool" {
  for_each = {
    for backend_address_pool in local.backend_address_pools : "${backend_address_pool.key}" => backend_address_pool
  }
  name = each.value.name
  loadbalancer_id = azurerm_lb.lb[each.value.load_balancer].id
}

resource "azurerm_network_interface_backend_address_pool_association" "network_interface_backend_address_pool_association" {
  for_each = {
    for backend_ip in local.load_balancer_backend_ips : "${backend_ip.key}" => backend_ip
  }
  ip_configuration_name = each.value.ip_configuration_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_address_pool[each.value.backend_address_pool].id
  #virtual_network_id = each.value.virtual_network_id
  network_interface_id = each.value.network_interface_id
}

resource "azurerm_lb_nat_rule" "nat_rule" {
  for_each = {
    for nat_rule in local.nat_rules : "${nat_rule.key}" => nat_rule
  }
  name = each.value.name
  resource_group_name = each.value.resource_group_name
  loadbalancer_id = azurerm_lb.lb[each.value.load_balancer].id
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  protocol = each.value.protocol
  backend_port = each.value.backend_port
  frontend_port_start = each.value.frontend_port_start
  frontend_port_end = each.value.frontend_port_end
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_address_pool[each.value.backend_address_pool].id
}

resource "azurerm_lb_probe" "probe" {
  for_each = {
    for probe in local.probes : "${probe.key}" => probe
  }
  name = each.value.name
  loadbalancer_id = azurerm_lb.lb[each.value.load_balancer].id
  port = each.value.port
  protocol = each.value.protocol
  request_path = each.value.request_path
  interval_in_seconds = each.value.interval_in_seconds
  number_of_probes = each.value.number_of_probes
}

resource "azurerm_lb_rule" "rule" {
  for_each = {
    for rule in local.rules : "${rule.key}" => rule
  }
  name = each.value.name
  loadbalancer_id = azurerm_lb.lb[each.value.load_balancer].id
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  frontend_port = each.value.frontend_port
  backend_port = each.value.backend_port
  probe_id = azurerm_lb_probe.probe["${each.value.load_balancer}.${each.value.probe}"].id
  protocol = each.value.protocol
  disable_outbound_snat = each.value.disable_outbound_snat
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  load_distribution = each.value.load_distribution
  enable_floating_ip = each.value.enable_floating_ip
  //backend_address_pool_ids = azurerm_lb_backend_address_pool.backend_address_pool[each.value.backend_address_pool].id
  backend_address_pool_ids = [for k, v in azurerm_lb_backend_address_pool.backend_address_pool : v.id if contains(each.value.backend_address_pools, replace(k, "${each.value.load_balancer}.", ""))]
}

resource "azurerm_lb_outbound_rule" "outbound_rule" {
  for_each = {
    for outbound_rule in local.outbound_rules : "${outbound_rule.key}" => outbound_rule
  }
  name = each.value.name
  loadbalancer_id = azurerm_lb.lb[each.value.load_balancer].id
  protocol = each.value.protocol
  allocated_outbound_ports = each.value.allocated_outbound_ports
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  enable_tcp_reset = each.value.enable_tcp_reset
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_address_pool[each.value.backend_address_pool].id

  dynamic "frontend_ip_configuration" {
    for_each = each.value.frontend_ip_configuration
    content {
        name = frontend_ip_configuration.value.name
    }
  }
}

  /*sku {
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
  }*/