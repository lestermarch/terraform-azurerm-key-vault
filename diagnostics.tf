resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  for_each = var.diagnostics.key_vault

  name               = each.key
  target_resource_id = azurerm_key_vault.main.id

  log_analytics_destination_type = each.value.log_analytics_destination_type
  log_analytics_workspace_id     = each.value.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = each.value.metric_categories

    content {
      category = metric.value
    }
  }
}
