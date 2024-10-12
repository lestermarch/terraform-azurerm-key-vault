# Enabling and Configuring Azure Monitor Alerts

This module supports a default set of recommended Azure Monitor alerts. These can be enabled collectively or individually by specifying an `action_group_id` in either the main `alert.key_vault` object, or per alert.

## 1.1. Enable all alerts with default configuration for a single action group

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = 2024-10-12"

  location            = "uksouth"
  resource_group_name = "rg-example"

  alert = {
    action_group_id = "/subscriptions/.../resourceGroups/rg-example/providers/Microsoft.Insights/actionGroups/ag-example"
  }
}
```

## 1.2. Customize alert configuration for some alerts

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = 2024-10-12"

  location            = "uksouth"
  resource_group_name = "rg-example"

  alert = {
    action_group_id = "/subscriptions/.../resourceGroups/rg-example/providers/Microsoft.Insights/actionGroups/ag-example"
    key_vault = {
      availability = {
        severity  = 3
        threshold = 80
      }
    }
  }
}
```

## 1.3. Enable individual alerts for different action groups

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = 2024-10-12"

  location            = "uksouth"
  resource_group_name = "rg-example"

  alert = {
    key_vault = {
      availability = {
        action_group_id = "/subscriptions/.../resourceGroups/rg-example/providers/Microsoft.Insights/actionGroups/ag-example-1"
      }
      deleted = {
        action_group_id = "/subscriptions/.../resourceGroups/rg-example/providers/Microsoft.Insights/actionGroups/ag-example-2"
      }
    }
  }
}
```
