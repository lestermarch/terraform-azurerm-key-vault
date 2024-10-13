# Activity Log Alerts
resource "azurerm_monitor_activity_log_alert" "key_vault_deleted" {
  # https://azure.github.io/azure-monitor-baseline-alerts/services/KeyVault/vaults/#activity-log-key-vault-delete
  count = local.alert.key_vault.deleted.deploy ? 1 : 0

  name                = local.alert.key_vault.deleted.alert_name
  location            = "global"
  resource_group_name = local.alert.key_vault.deleted.resource_group_name
  tags                = var.resource_tags

  description = "Action will be triggered when a key vault is deleted."
  enabled     = var.alert.key_vault.deleted.enabled
  scopes      = [azurerm_key_vault.main.id]

  action {
    action_group_id = local.alert.key_vault.deleted.action_group_id
  }

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.KeyVault/vaults/delete"
    statuses       = var.alert.key_vault.deleted.statuses
  }
}

# Resource Metrics Alerts
resource "azurerm_monitor_metric_alert" "key_vault_availability" {
  # https://azure.github.io/azure-monitor-baseline-alerts/services/KeyVault/vaults/#availability
  count = local.alert.key_vault.availability.deploy ? 1 : 0

  name                = local.alert.key_vault.availability.alert_name
  resource_group_name = local.alert.key_vault.availability.resource_group_name
  tags                = var.resource_tags

  description = "Action will be triggered when the availability of the key vault falls below ${var.alert.key_vault.availability.threshold}%."
  enabled     = var.alert.key_vault.availability.enabled
  frequency   = "PT1M"
  severity    = var.alert.key_vault.availability.severity
  scopes      = [azurerm_key_vault.main.id]
  window_size = "PT5M"

  action {
    action_group_id = local.alert.key_vault.availability.action_group_id
  }

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "Availability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = var.alert.key_vault.availability.threshold
  }
}

resource "azurerm_monitor_metric_alert" "key_vault_saturation" {
  # https://azure.github.io/azure-monitor-baseline-alerts/services/KeyVault/vaults/#saturationshoebox
  count = local.alert.key_vault.saturation.deploy ? 1 : 0

  name                = local.alert.key_vault.saturation.alert_name
  resource_group_name = local.alert.key_vault.saturation.resource_group_name
  tags                = var.resource_tags

  description = "Action will be triggered when the saturation of the key vault exceeds ${var.alert.key_vault.saturation.threshold}%."
  enabled     = var.alert.key_vault.saturation.enabled
  frequency   = "PT5M"
  severity    = var.alert.key_vault.saturation.severity
  scopes      = [azurerm_key_vault.main.id]
  window_size = "PT5M"

  action {
    action_group_id = local.alert.key_vault.saturation.action_group_id
  }

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "SaturationShoebox"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.alert.key_vault.saturation.threshold
  }
}

resource "azurerm_monitor_metric_alert" "key_vault_service_api_hit" {
  # https://azure.github.io/azure-monitor-baseline-alerts/services/KeyVault/vaults/#serviceapihit
  count = local.alert.key_vault.service_api_hit.deploy ? 1 : 0

  name                = local.alert.key_vault.service_api_hit.alert_name
  resource_group_name = local.alert.key_vault.service_api_hit.resource_group_name
  tags                = var.resource_tags

  description = "Action will be triggered when the service API hit of the key vault exceeds ${var.alert.key_vault.service_api_hit.threshold}."
  enabled     = var.alert.key_vault.service_api_hit.enabled
  frequency   = "PT5M"
  severity    = var.alert.key_vault.service_api_hit.severity
  scopes      = [azurerm_key_vault.main.id]
  window_size = "PT5M"

  action {
    action_group_id = local.alert.key_vault.service_api_hit.action_group_id
  }

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "ServiceApiHit"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.alert.key_vault.service_api_hit.threshold
  }
}

resource "azurerm_monitor_metric_alert" "key_vault_service_api_latency" {
  # https://azure.github.io/azure-monitor-baseline-alerts/services/KeyVault/vaults/#service-api-latency
  count = local.alert.key_vault.service_api_latency.deploy ? 1 : 0

  name                = local.alert.key_vault.service_api_latency.alert_name
  resource_group_name = local.alert.key_vault.service_api_latency.resource_group_name
  tags                = var.resource_tags

  description = "Action will be triggered when the service API latency of the key vault exceeds ${var.alert.key_vault.service_api_latency.threshold}ms."
  enabled     = var.alert.key_vault.service_api_latency.enabled
  frequency   = "PT5M"
  severity    = var.alert.key_vault.service_api_latency.severity
  scopes      = [azurerm_key_vault.main.id]
  window_size = "PT5M"

  action {
    action_group_id = local.alert.key_vault.service_api_latency.action_group_id
  }

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "ServiceApiLatency"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.alert.key_vault.service_api_latency.threshold
  }
}

resource "azurerm_monitor_metric_alert" "key_vault_service_api_result_anomaly" {
  # https://azure.github.io/azure-monitor-baseline-alerts/services/KeyVault/vaults/#service-api-result
  count = local.alert.key_vault.service_api_result_anomaly.deploy ? 1 : 0

  name                = local.alert.key_vault.service_api_result_anomaly.alert_name
  resource_group_name = local.alert.key_vault.service_api_result_anomaly.resource_group_name
  tags                = var.resource_tags

  description = "Action will be triggered based on service API result anomalies."
  enabled     = var.alert.key_vault.service_api_result_anomaly.enabled
  frequency   = "PT5M"
  severity    = var.alert.key_vault.service_api_result_anomaly.severity
  scopes      = [azurerm_key_vault.main.id]
  window_size = "PT5M"

  action {
    action_group_id = local.alert.key_vault.service_api_result_anomaly.action_group_id
  }

  dynamic_criteria {
    metric_namespace         = "Microsoft.KeyVault/vaults"
    metric_name              = "ServiceApiResult"
    aggregation              = "Average"
    operator                 = "GreaterThan"
    alert_sensitivity        = var.alert.key_vault.service_api_result_anomaly.sensitivity
    evaluation_failure_count = 4
    evaluation_total_count   = 4
  }
}

resource "azurerm_monitor_metric_alert" "key_vault_service_api_result_rate_limit" {
  # https://azure.github.io/azure-monitor-baseline-alerts/services/KeyVault/vaults/#serviceapiresult
  count = local.alert.key_vault.service_api_result_rate_limit.deploy ? 1 : 0

  name                = local.alert.key_vault.service_api_result_rate_limit.alert_name
  resource_group_name = local.alert.key_vault.service_api_result_rate_limit.resource_group_name
  tags                = var.resource_tags

  description = "Action will be triggered based on service API result rate limits."
  enabled     = var.alert.key_vault.service_api_result_rate_limit.enabled
  frequency   = "PT5M"
  severity    = var.alert.key_vault.service_api_result_rate_limit.severity
  scopes      = [azurerm_key_vault.main.id]
  window_size = "PT30M"

  action {
    action_group_id = local.alert.key_vault.service_api_result_rate_limit.action_group_id
  }

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "ServiceApiResult"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {
      name     = "statuscode"
      operator = "Include"
      values   = ["429"]
    }
  }
}
