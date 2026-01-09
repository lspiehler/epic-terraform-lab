resource "azurerm_container_group" "container_group" {
  for_each = {
    for container_group in local.container_groups : "${container_group.key}" => container_group
  }
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  os_type = each.value.os_type
  ip_address_type = each.value.ip_address_type
  dns_name_label = each.value.dns_name_label
  subnet_ids = each.value.subnet_ids

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [1]
    content {
      type = each.value.identity.type
      identity_ids = each.value.identity.identity_ids
    }
  }

  dynamic "exposed_port" {
    for_each = each.value.exposed_port
    content {
      port = exposed_port.value.port
      protocol = exposed_port.value.protocol
    }
  }

  dynamic "image_registry_credential" {
    for_each = each.value.image_registry_credential
    content {
      server = image_registry_credential.value.server
      username = image_registry_credential.value.username
      password = image_registry_credential.value.password
    }
  }

  dynamic "container" {
    for_each = each.value.container
    content {
        name = container.value.name != null ? container.value.name : container.key
        image = container.value.image
        cpu = container.value.cpu
        memory = container.value.memory
        environment_variables = container.value.environment_variables
        secure_environment_variables = container.value.secure_environment_variables
        dynamic "ports" {
          for_each = container.value.ports
          content {
            port = ports.value.port
            protocol = ports.value.protocol
          }
        }
        dynamic "volume" {
          for_each = container.value.volume
          content {
            name = volume.value.name == null ? volume.key : volume.value.name
            mount_path = volume.value.mount_path
            storage_account_name = var.mod_storage_account[volume.value.storage_account].name
            storage_account_key = var.mod_storage_account[volume.value.storage_account].primary_access_key
            share_name = var.mod_storage_share["${volume.value.storage_account}.${volume.value.share}"].name
            read_only = volume.value.read_only
          }
        }
        commands = container.value.commands
    }
  }

  tags = each.value.tags
}