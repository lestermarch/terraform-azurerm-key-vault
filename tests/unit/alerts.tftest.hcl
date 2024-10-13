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
    alert = {
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock"
    }
  }

  # Key vault delete alert
  assert {
    condition     = contains([for action in azurerm_monitor_activity_log_alert.key_vault_deleted[0].action : action.action_group_id], "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock")
    error_message = "Key vault delete alert should be associated with the correct action group."
  }

  assert {
    condition     = azurerm_monitor_activity_log_alert.key_vault_deleted[0].enabled == true
    error_message = "Key vault delete alert should be enabled."
  }

  assert {
    condition     = contains([for criteria in azurerm_monitor_activity_log_alert.key_vault_deleted[0].criteria : criteria.operation_name], "Microsoft.KeyVault/vaults/delete")
    error_message = "Key vault delete alert should have the correct operation name."
  }

  assert {
    condition     = contains([for criteria in azurerm_monitor_activity_log_alert.key_vault_deleted[0].criteria : criteria.statuses[0]], "Succeeded")
    error_message = "Key vault delete alert should have the correct status."
  }

  # Key vault availability alert
  assert {
    condition     = contains([for action in azurerm_monitor_metric_alert.key_vault_availability[0].action : action.action_group_id], "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock")
    error_message = "Key vault availability alert should be associated with the correct action group."
  }

  assert {
    condition     = azurerm_monitor_metric_alert.key_vault_availability[0].enabled == true
    error_message = "Key vault availability alert should be enabled."
  }

  assert {
    condition     = contains([for criteria in azurerm_monitor_metric_alert.key_vault_availability[0].criteria : criteria.threshold], 90)
    error_message = "Key vault availability alert should have a threshold of 90."
  }

  # Key vault saturation alert
  assert {
    condition     = contains([for action in azurerm_monitor_metric_alert.key_vault_saturation[0].action : action.action_group_id], "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock")
    error_message = "Key vault saturation alert should be associated with the correct action group."
  }

  assert {
    condition     = azurerm_monitor_metric_alert.key_vault_saturation[0].enabled == true
    error_message = "Key vault saturation alert should be enabled."
  }

  assert {
    condition     = contains([for criteria in azurerm_monitor_metric_alert.key_vault_saturation[0].criteria : criteria.threshold], 75)
    error_message = "Key vault saturation alert should have a threshold of 75."
  }

  # Key vault sevice API hit alert
  assert {
    condition     = contains([for action in azurerm_monitor_metric_alert.key_vault_service_api_hit[0].action : action.action_group_id], "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock")
    error_message = "Key vault service API hit alert should be associated with the correct action group."
  }

  assert {
    condition     = azurerm_monitor_metric_alert.key_vault_service_api_hit[0].enabled == true
    error_message = "Key vault service API hit alert should be enabled."
  }

  assert {
    condition     = contains([for criteria in azurerm_monitor_metric_alert.key_vault_service_api_hit[0].criteria : criteria.threshold], 80)
    error_message = "Key vault service API hit alert should have a threshold of 80."
  }

  # Key vault service API latency alert
  assert {
    condition     = contains([for action in azurerm_monitor_metric_alert.key_vault_service_api_latency[0].action : action.action_group_id], "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock")
    error_message = "Key vault service API latency alert should be associated with the correct action group."
  }

  assert {
    condition     = azurerm_monitor_metric_alert.key_vault_service_api_latency[0].enabled == true
    error_message = "Key vault service API latency alert should be enabled."
  }

  assert {
    condition     = contains([for criteria in azurerm_monitor_metric_alert.key_vault_service_api_latency[0].criteria : criteria.threshold], 1000)
    error_message = "Key vault service API latency alert should have a threshold of 1000."
  }

  # Key vault service API result anomaly alert
  assert {
    condition     = contains([for action in azurerm_monitor_metric_alert.key_vault_service_api_result_anomaly[0].action : action.action_group_id], "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock")
    error_message = "Key vault service API result anomaly alert should be associated with the correct action group."
  }

  assert {
    condition     = azurerm_monitor_metric_alert.key_vault_service_api_result_anomaly[0].enabled == true
    error_message = "Key vault service API result anomaly alert should be enabled."
  }

  assert {
    condition     = contains([for criteria in azurerm_monitor_metric_alert.key_vault_service_api_result_anomaly[0].dynamic_criteria : criteria.alert_sensitivity], "Medium")
    error_message = "Key vault service API result anomaly alert should have a sensitivity of medium."
  }

  # Key vault rate limit alert
  assert {
    condition     = contains([for action in azurerm_monitor_metric_alert.key_vault_service_api_result_rate_limit[0].action : action.action_group_id], "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock")
    error_message = "Key vault rate limit alert should be associated with the correct action group."
  }

  assert {
    condition     = azurerm_monitor_metric_alert.key_vault_service_api_result_rate_limit[0].enabled == true
    error_message = "Key vault rate limit alert should be enabled."
  }
}

run "alternative_action_group_id" {
  command = plan

  variables {
    alert = {
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock"
      key_vault = {
        availability = {
          action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock-alternative"
        }
      }
    }
  }

  # Key vault delete alert
  assert {
    condition     = contains([for action in azurerm_monitor_activity_log_alert.key_vault_deleted[0].action : action.action_group_id], "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock")
    error_message = "Key vault delete alert should be associated with the correct action group."
  }

  # Key vault availability alert
  assert {
    condition     = contains([for action in azurerm_monitor_metric_alert.key_vault_availability[0].action : action.action_group_id], "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock-alternative")
    error_message = "Key vault availability alert should be associated with the correct action group."
  }
}

run "alternative_alert_name" {
  command = plan

  variables {
    alert = {
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock"
      key_vault = {
        availability = {
          alert_name = "kv-mock-availability-alternative"
        }
      }
    }
  }

  # Key vault availability alert
  assert {
    condition     = azurerm_monitor_metric_alert.key_vault_availability[0].name == "kv-mock-availability-alternative"
    error_message = "Key vault availability alert should have the correct name."
  }
}

run "alternative_alert_severity" {
  command = plan

  variables {
    alert = {
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock"
      key_vault = {
        availability = {
          severity = 2
        }
      }
    }
  }

  # Key vault availability alert
  assert {
    condition     = azurerm_monitor_metric_alert.key_vault_availability[0].severity == 2
    error_message = "Key vault availability alert should have the correct severity."
  }

  # Key vault saturation alert
  assert {
    condition     = azurerm_monitor_metric_alert.key_vault_saturation[0].severity == 3
    error_message = "Key vault saturation alert should have the correct severity."
  }
}

run "alternative_alert_threshold" {
  command = plan

  variables {
    alert = {
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock"
      key_vault = {
        availability = {
          threshold = 80
        }
      }
    }
  }

  # Key vault availability alert
  assert {
    condition     = contains([for criteria in azurerm_monitor_metric_alert.key_vault_availability[0].criteria : criteria.threshold], 80)
    error_message = "Key vault availability alert should have the correct threshold."
  }

  # Key vault saturation alert
  assert {
    condition     = contains([for criteria in azurerm_monitor_metric_alert.key_vault_saturation[0].criteria : criteria.threshold], 75)
    error_message = "Key vault saturation alert should have the correct threshold."
  }
}

run "alternative_resource_group_name" {
  command = plan

  variables {
    alert = {
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock"
      key_vault = {
        availability = {
          resource_group_name = "rg-alert-mock"
        }
      }
    }
  }

  # Key vault delete alert
  assert {
    condition     = azurerm_monitor_activity_log_alert.key_vault_deleted[0].resource_group_name == "rg-mock"
    error_message = "Key vault delete alert should be in the rg-mock resource group."
  }

  # Key vault availability alert
  assert {
    condition     = azurerm_monitor_metric_alert.key_vault_availability[0].resource_group_name == "rg-alert-mock"
    error_message = "Key vault availability alert should be in the rg-alert-mock resource group."
  }
}

run "selective_enablement" {
  command = plan

  variables {
    alert = {
      key_vault = {
        availability = {
          action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock"
        }
        saturation = {
          action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Insights/actionGroups/ag-mock"
          enabled         = false
        }
      }
    }
  }

  # Key vault availability alert
  assert {
    condition     = azurerm_monitor_metric_alert.key_vault_availability[0].enabled == true
    error_message = "Key vault availability alert should be enabled."
  }

  # Key vault saturation alert
  assert {
    condition     = azurerm_monitor_metric_alert.key_vault_saturation[0].enabled == false
    error_message = "Key vault saturation alert should be disabled."
  }
}
