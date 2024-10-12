resource "azurerm_role_assignment" "key_vault" {
  for_each = var.role_assignments.key_vault

  description                      = each.value.description
  principal_id                     = each.value.principal_id
  principal_type                   = each.value.principal_type
  role_definition_name             = each.value.role_definition_name
  scope                            = azurerm_key_vault.main.id
  skip_service_principal_aad_check = each.value.skip_service_principal_check
}
