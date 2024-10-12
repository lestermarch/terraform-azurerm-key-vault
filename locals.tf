locals {
  # Generate default alert names and resource group associations if not provided
  alert = {
    key_vault = {
      for alert, config in var.alert.key_vault : alert => {
        action_group_id     = try(coalesce(config.action_group_id, var.alert.action_group_id), null)
        alert_name          = coalesce(config.alert_name, "${azurerm_key_vault.main.name}-${join("", [for word in split("_", alert) : title(word)])}")
        deploy              = var.alert.action_group_id != null || config.action_group_id != null
        resource_group_name = coalesce(config.resource_group_name, var.resource_group_name)
        tags                = try(coalesce(config.tags, var.resource_tags), null)
      }
    }
  }

  # Generate default endpoint names, NIC names, resource group associations, and tags if not provided
  private_endpoint = {
    key_vault = {
      for subresource, config in var.private_endpoint.key_vault : subresource => {
        endpoint_name          = coalesce(config.endpoint_name, "${azurerm_key_vault.main.name}-pe-${subresource}")
        network_interface_name = coalesce(config.network_interface_name, "${azurerm_key_vault.main.name}-pe-nic-${subresource}")
        private_dns_zone_name  = regex(".*?/privateDnsZones/(.*)", config.private_dns_zone_id[0])[0]
        resource_group_name    = coalesce(config.resource_group_name, var.resource_group_name)
        tags                   = try(coalesce(config.tags, var.resource_tags), null)
      }
    }
  }

  # Generate a name for resources if not provided
  resource_name = {
    key_vault = coalesce(var.resource_name.key_vault, "kv-${local.resource_suffix}")
  }

  # Generated resource suffix for randomized resource names
  resource_suffix = "${random_pet.resource_suffix.id}-${random_integer.resource_suffix.id}"
}
