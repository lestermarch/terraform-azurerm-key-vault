# Azure Key Vault

This module provisions an [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) with options for configuring [private endpoints](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview), [diagnostic logging](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings), [role-based access control (RBAC) assignments](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview), and [Azure Monitor alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview) at deployment time.

## Design Decisions

### Access Model

This module exclusively supports Azure RBAC for access control. Access policies are not supported in this module. This approach provides:

- Centralized governance over access.
- Simplified role assignment via Entra ID roles.
- Enhanced insights into role assignments.

Roles can be assigned through the `role_assignment` variable. See [usage examples](#example-usage) for configuration guidance.

### Network Security

This module disables public access by default. This approach provides:

- Enhanced security by requiring explicit configuration for the desired network access method.

Public and private access can be configured through the `network_access` and `private_endpoint` variables. See the [usage examples](#example-usage) for configuration guidance.

### Recovery

This module enforces the purge protection and soft-delete features. This approach provides:

- Ability to recover deleted objects or vaults within a given time period.

The retention period can be adjusted through the `delete_retention_days` variable.

## Example Usage

The below links provide documentation on example usage for features specific to this module

- [Enabling and Configuring Azure Monitor Alerts](docs/example-usage-alerts.md)
- [Enabling and Configuring Diagnostic Settings](docs/example-usage-diagnostics.md)
- [Enabling and Configuring Public Network Access](docs/example-usage-public-access.md)
- [Enabling and Configuring Private Network Access](docs/example-usage-private-access.md)
- [Enabling and Configuring Role Assignments](docs/example-usage-rbac.md)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_monitor_activity_log_alert.key_vault_deleted](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert) | resource |
| [azurerm_monitor_diagnostic_setting.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_metric_alert.key_vault_availability](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.key_vault_saturation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.key_vault_service_api_hit](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.key_vault_service_api_latency](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.key_vault_service_api_result_anomaly](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.key_vault_service_api_result_rate_limit](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_private_endpoint.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [random_integer.resource_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [random_pet.resource_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The region into which resources will be deployed. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group into which resources will be deployed. | `string` | n/a | yes |
| <a name="input_alert"></a> [alert](#input\_alert) | An object used to define alerts for resources, in the format:<pre>{<br/>  key_vault = {<br/>    availability = {<br/>      action_group_id     = "/subscriptions/.../resourceGroups/rg-example/providers/Microsoft.Insights/actionGroups/ag-example"<br/>      alert_name          = "kv-example-Availability"<br/>      enabled             = true<br/>      resource_group_name = "rg-alerts-example"<br/>      severity            = 3<br/>      threshold           = 95<br/>    }<br/>    saturation                    = { ... }<br/>    service_api_hit               = { ... }<br/>    service_api_latency           = { ... }<br/>    service_api_result_anomaly    = { ... }<br/>    service_api_result_rate_limit = { ... }<br/>  }<br/>}</pre>The default action group for all alerts can be set using the `action_group_id` attribute.<br/>Action groups defined per alert will override the default action group.<br/>Either the default `action_group_id` or an `action_group_id` per alert must be provided. | <pre>object({<br/>    action_group_id = optional(string)<br/>    key_vault = optional(object({<br/>      availability = optional(object({<br/>        action_group_id     = optional(string, null)<br/>        alert_name          = optional(string)<br/>        enabled             = optional(bool, true)<br/>        resource_group_name = optional(string)<br/>        severity            = optional(number, 1)<br/>        tags                = optional(map(string))<br/>        threshold           = optional(number, 90)<br/>      }), {})<br/>      deleted = optional(object({<br/>        action_group_id     = optional(string, null)<br/>        alert_name          = optional(string)<br/>        enabled             = optional(bool, true)<br/>        resource_group_name = optional(string)<br/>        statuses            = optional(list(string), ["Succeeded"])<br/>        tags                = optional(map(string))<br/>      }), {})<br/>      saturation = optional(object({<br/>        action_group_id     = optional(string, null)<br/>        alert_name          = optional(string)<br/>        enabled             = optional(bool, true)<br/>        resource_group_name = optional(string)<br/>        severity            = optional(number, 3)<br/>        tags                = optional(map(string))<br/>        threshold           = optional(number, 75)<br/>      }), {})<br/>      service_api_hit = optional(object({<br/>        action_group_id     = optional(string, null)<br/>        alert_name          = optional(string)<br/>        enabled             = optional(bool, true)<br/>        resource_group_name = optional(string)<br/>        severity            = optional(number, 3)<br/>        tags                = optional(map(string))<br/>        threshold           = optional(number, 80)<br/>      }), {})<br/>      service_api_latency = optional(object({<br/>        action_group_id     = optional(string, null)<br/>        alert_name          = optional(string)<br/>        enabled             = optional(bool, true)<br/>        resource_group_name = optional(string)<br/>        severity            = optional(number, 3)<br/>        tags                = optional(map(string))<br/>        threshold           = optional(number, 1000)<br/>      }), {})<br/>      service_api_result_anomaly = optional(object({<br/>        action_group_id     = optional(string, null)<br/>        alert_name          = optional(string)<br/>        enabled             = optional(bool, true)<br/>        resource_group_name = optional(string)<br/>        severity            = optional(number, 3)<br/>        sensitivity         = optional(string, "Medium")<br/>        tags                = optional(map(string))<br/>      }), {})<br/>      service_api_result_rate_limit = optional(object({<br/>        action_group_id     = optional(string, null)<br/>        alert_name          = optional(string)<br/>        enabled             = optional(bool, true)<br/>        resource_group_name = optional(string)<br/>        severity            = optional(number, 3)<br/>        tags                = optional(map(string))<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_delete_retention_days"></a> [delete\_retention\_days](#input\_delete\_retention\_days) | The number of days to retain soft-deleted keys, secrets, and certificates. | `number` | `7` | no |
| <a name="input_diagnostics"></a> [diagnostics](#input\_diagnostics) | An object used to define diagnostic settings for resources, in the format:<pre>{<br/>  key_vault = {<br/>    default = {<br/>      log_analytics_workspace_id     = "/subscriptions/.../providers/Microsoft.OperationalInsights/workspaces/log-example"<br/>      log_analytics_destination_type = "AzureDiagnostics"<br/>      log_categories                 = ["AuditEvent"]<br/>    }<br/>  }<br/>}</pre> | <pre>object({<br/>    key_vault = optional(map(object({<br/>      log_analytics_workspace_id     = string<br/>      log_analytics_destination_type = optional(string, "AzureDiagnostics")<br/>      log_categories                 = optional(list(string), ["AuditEvent"])<br/>      metric_categories              = optional(list(string), ["AllMetrics"])<br/>    })), {})<br/>  })</pre> | `{}` | no |
| <a name="input_enable_for_deployment"></a> [enable\_for\_deployment](#input\_enable\_for\_deployment) | Determines if virtual machines can retrieve secrets from the key vault during deployment. | `bool` | `false` | no |
| <a name="input_enable_for_disk_encryption"></a> [enable\_for\_disk\_encryption](#input\_enable\_for\_disk\_encryption) | Determines if the Azure disk encryption service can retrieve secrets from the key vault. | `bool` | `false` | no |
| <a name="input_enable_for_template_deployment"></a> [enable\_for\_template\_deployment](#input\_enable\_for\_template\_deployment) | Determines if Azure Resource Manager can retrieve secrets from the key vault during template deployment. | `bool` | `false` | no |
| <a name="input_enable_public_access"></a> [enable\_public\_access](#input\_enable\_public\_access) | Determines if public network access should be enabled. | `bool` | `false` | no |
| <a name="input_network_access"></a> [network\_access](#input\_network\_access) | An object used to define network access to key vault, in the format:<pre>{<br/>  bypass         = "AzureServices"<br/>  default_action = "Deny"<br/>  ip_rules = [<br/>    "80.170.100.82/32",<br/>    "80.170.101.0/24"<br/>  ]<br/>  virtual_network_subnet_ids = [<br/>    "/subscriptions/.../providers/Microsoft.Network/virtualNetworks/vnet-example/subnets/ExampleSubnet"<br/>  ]<br/>}</pre>Subnets defined in `virtual_network_subnet_ids` should be configured with service endpoint for `Microsoft.KeyVault`. | <pre>object({<br/>    bypass                     = optional(string, "AzureServices")<br/>    default_action             = optional(string, "Deny")<br/>    ip_rules                   = optional(list(string))<br/>    virtual_network_subnet_ids = optional(list(string))<br/>  })</pre> | <pre>{<br/>  "bypass": "AzureServices",<br/>  "default_action": "Deny"<br/>}</pre> | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | An object used to define private endpoints for resources, in the format:<pre>{<br/>  key_vault = {<br/>    vault = {<br/>      private_dns_zone_ids = [<br/>        "/subscriptions/.../providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"<br/>      ]<br/>      subnet_id = "/subscriptions/.../providers/Microsoft.Network/virtualNetworks/vnet-example/subnets/ExampleSubnet"<br/>    }<br/>  }<br/>}</pre> | <pre>object({<br/>    key_vault = optional(map(object({<br/>      private_dns_zone_ids   = list(string)<br/>      subnet_id              = string<br/>      endpoint_name          = optional(string)<br/>      network_interface_name = optional(string)<br/>      resource_group_name    = optional(string)<br/>      tags                   = optional(map(string))<br/>    })), {})<br/>  })</pre> | `{}` | no |
| <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name) | An object used to define explicit resource names, in the format:<pre>{<br/>  key_vault = "kv-example-123"<br/>}</pre>Resource names will be randomly generated if not provided. | <pre>object({<br/>    key_vault = optional(string, null)<br/>  })</pre> | `{}` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | A map of key-value pairs to use as resource tags. | `map(string)` | `null` | no |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | An object used to define role assignments for resources, in the format:<pre>{<br/>  key_vault = {<br/>    service_principal_key_vault_administrator = {<br/>      principal_id                 = "0000000000-0000-0000-0000-000000000001"<br/>      principal_type               = "ServicePrincipal"<br/>      role_definition_name         = "Key Vault Administrator"<br/>      skip_service_principal_check = true<br/>    }<br/>  }<br/>}</pre> | <pre>object({<br/>    key_vault = optional(map(object({<br/>      principal_id                 = string<br/>      role_definition_name         = string<br/>      description                  = optional(string)<br/>      principal_type               = optional(string, "Group")<br/>      skip_service_principal_check = optional(bool, false)<br/>    })), {})<br/>  })</pre> | `{}` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The key vault SKU to provision. | `string` | `"Standard"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | The ID of the key vault. |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | The name of the key vault. |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | The URI of the key vault. |
<!-- END_TF_DOCS -->
