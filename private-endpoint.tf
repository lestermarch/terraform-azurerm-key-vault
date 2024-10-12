resource "azurerm_private_endpoint" "key_vault" {
  for_each = var.private_endpoint.key_vault

  name                = local.private_endpoint.key_vault[each.key].endpoint_name
  location            = var.location
  resource_group_name = local.private_endpoint.key_vault[each.key].resource_group_name
  tags                = local.private_endpoint.key_vault[each.key].tags

  custom_network_interface_name = local.private_endpoint.key_vault[each.key].network_interface_name
  subnet_id                     = each.value.subnet_id

  private_dns_zone_group {
    name                 = local.private_endpoint.key_vault[each.key].private_dns_zone_name
    private_dns_zone_ids = each.value.private_dns_zone_ids
  }

  private_service_connection {
    name                           = local.private_endpoint.key_vault[each.key].endpoint_name
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = [each.key]
    is_manual_connection           = false
  }
}
