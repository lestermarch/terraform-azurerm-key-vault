resource "azurerm_key_vault" "main" {
  #checkov:skip=CKV2_AZURE_32: [TODO] Support private endpoints
  name                = local.resource_name.key_vault
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.resource_tags

  enabled_for_deployment          = var.enable_for_deployment
  enabled_for_disk_encryption     = var.enable_for_disk_encryption
  enabled_for_template_deployment = var.enable_for_template_deployment
  enable_rbac_authorization       = true
  public_network_access_enabled   = var.enable_public_access
  purge_protection_enabled        = true
  sku_name                        = lower(var.sku)
  soft_delete_retention_days      = var.delete_retention_days
  tenant_id                       = data.azurerm_client_config.context.tenant_id

  network_acls {
    bypass                     = var.network_access.bypass
    default_action             = var.network_access.default_action
    ip_rules                   = var.network_access.ip_rules
    virtual_network_subnet_ids = var.network_access.virtual_network_subnet_ids
  }
}
