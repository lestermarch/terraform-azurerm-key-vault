# Enabling and Configuring Diagnostic Settings

This module supports a default set of diagnostic settings to forward to a Log Analytics workspace. One or more diagnostic settings can be configured to send to multiple log stores.

## 1.1. Enable default diagnostics to a single Log Analytics workspace

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = "2024-10-12"

  location            = "uksouth"
  resource_group_name = "rg-example"

  diagnostics = {
    key_vault = {
      default = {
        log_analytics_workspace_id = "/subscriptions/.../providers/Microsoft.OperationalInsights/workspaces/log-example"
      }
    }
  }
}
```

## 1.2. Customize diagnostic categories

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = "2024-10-12"

  location            = "uksouth"
  resource_group_name = "rg-example"

  diagnostics = {
    key_vault = {
      default = {
        log_analytics_workspace_id = "/subscriptions/.../providers/Microsoft.OperationalInsights/workspaces/log-example"
        log_categories             = ["AuditEvent", "AzurePolicyEvaluationDetails"]
        metric_categories          = []
      }
    }
  }
}
```

> [!Note]
> In the case of Key Vault, the only metric category is "AllMetrics" which is specified by default. This can be disabled by providing an empty list instead.

## 1.3. Enable default diagnostics to multiple Log Analytics workspaces

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = "2024-10-12"

  location            = "uksouth"
  resource_group_name = "rg-example"

  diagnostics = {
    key_vault = {
      log_store_one = {
        log_analytics_workspace_id = "/subscriptions/.../providers/Microsoft.OperationalInsights/workspaces/log-example-one"
      }
      log_store_two = {
        log_analytics_workspace_id = "/subscriptions/.../providers/Microsoft.OperationalInsights/workspaces/log-example-two"
      }
    }
  }
}
```
