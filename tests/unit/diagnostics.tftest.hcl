mock_provider "azurerm" {
  source = "./tests/unit"
}

variables {
  location            = "uksouth"
  resource_group_name = "rg-mock"
  resource_names      = {
    key_vault = "kv-mock"
  }
}

run "default_configuration" {
  command = plan

  variables {
    diagnostics = {
      key_vault = {
        default = {
          log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.OperationalInsights/workspaces/log-mock"
        }
      }
    }
  }

  # Log analytics workspace ID
  assert {
    condition     = azurerm_monitor_diagnostic_setting.key_vault["default"].log_analytics_workspace_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.OperationalInsights/workspaces/log-mock"
    error_message = "Diagnostic setting should send logs to the correct Log Analytics workspace."
  }

  # Log analytics destination type
  assert {
    condition     = azurerm_monitor_diagnostic_setting.key_vault["default"].log_analytics_destination_type == "AzureDiagnostics"
    error_message = "Diagnostic setting should use the correct destination type."
  }

  # Diagnostic log categories
  assert {
    condition     = contains([for log in azurerm_monitor_diagnostic_setting.key_vault["default"].enabled_log : log.category], "AuditEvent")
    error_message = "Diagnostic setting should include all log categories."
  }

  # Diagnostic metric categories
  assert {
    condition     = contains([for metric in azurerm_monitor_diagnostic_setting.key_vault["default"].metric : metric.category], "AllMetrics")
    error_message = "Diagnostic setting should include all metric categories."
  }
}

run "alternative_diagnostic_categories" {
  command = plan

  variables {
    diagnostics = {
      key_vault = {
        alternative = {
          log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.OperationalInsights/workspaces/log-mock"
          log_categories            = ["mockOne", "mockTwo"]
          metric_categories         = ["mockThree"]
        }
      }
    }
  }

  # Diagnostic log categories
  assert {
    condition     = contains([for log in azurerm_monitor_diagnostic_setting.key_vault["alternative"].enabled_log : log.category], "mockOne")
    error_message = "Diagnostic setting should include the Write log category."
  }

  assert {
    condition     = contains([for log in azurerm_monitor_diagnostic_setting.key_vault["alternative"].enabled_log : log.category], "mockTwo")
    error_message = "Diagnostic setting should include the Delete log category."
  }

  # Diagnostic metric categories
  assert {
    condition     = contains([for metric in azurerm_monitor_diagnostic_setting.key_vault["alternative"].metric : metric.category], "mockThree")
    error_message = "Diagnostic setting should include all metric categories."
  }
}
