# Azure Key Vault

This module provisions an Azure Key Vault with options for configuring private endpoints, diagnostic logging, role-based access control (RBAC) assignments, and Azure Monitor alerts at deployment time.

## Design Decisions

### Access Model

Key vault support two methods of data-plane access control assignment:

- Access policies offer fine-grained control of the key vault data-plane by directly assigning an Entra ID principal to specific operations on certificates, keys, secrets, and storage within the vault.
- Azure RBAC offers centralized control and governance over access to to the key vault data-plane by abstracting data-plane access to Entra ID roles. Principals are assigned to one or more Entra ID roles specific to key vault, which grants a set of predefined operational permissions.

This module supports only the Azure RBAC access model to enforce enhanced insight and governance of role assignments. Azure RBAC assignments can be configured when calling the module through the `role_assignments` variable. No interface is provided for configuring access through access policies.

### Network Security

Key vault is a PaaS resource which supports both public and private endpoints. Public endpoints may be configured with an IP address allow list (firewall), and/or a subnet allow list (service endpoints).

This module sets the default public endpoint action to `Deny`. This means, to access the key vault data plane, one of two access modes must be configured:

- The public endpoint may be configured to allow access to [specific IP addresses](#enable-public-endpoint-with-firewall), [specific subnets](#enable-public-endpoint-with-service-endpoints), or [opened completely](#enable-public-endpoint-without-restriction).
- A [private endpoint may be provisioned](#provision-a-private-endpoint) to allow access through a virtual network subnet.

### Recovery

Key vault supports recovery of data-plane objects, as well as the key vault itself through two methods:

- Purge protection allows the key vault to be recovered in the case of accidental deletion for a defined period of time.
- Soft delete allows internal key vault resources to be recovered in the case of accidental deletion for a defined period of time.

This module forces the enablement of purge protection and provides no interface for disabling this configuration. In addition, soft-delete is enforced at the minimum retention period of 7 days. An interface is provided to configure this between 7 and 90 days.

## Example Usage

This section provides some examples of customizing the default module configuration.

### Diagnostic Logging

Diagnostic logging is supported using Log Analytics as the target log store.

#### Enable Diagnostics to Log Analytics

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

### Public Access

To access the Key Vault data plane over public endpoint the `enable_public_access` should be changed to `true`. However, in this configuration it is highly recommended to also use the public endpoint firewall or service endpoints to restrict access to trusted sources only. These can be enabled through the `network_access` variable.

#### Enable Public Endpoint with Firewall

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = "2024-10-12"

  location            = "uksouth"
  resource_group_name = "rg-example"

  enable_public_access = true
  network_access = {
    ip_rules = [
      "80.170.100.82/32",
      "80.170.101.0/24"
    ]
  }
}
```

#### Enable Public Endpoint with Service Endpoints

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = "2024-10-12"

  location            = "uksouth"
  resource_group_name = "rg-example"

  enable_public_access = true
  network_access = {
    virtual_network_subnet_ids = [
      "/subscriptions/.../providers/Microsoft.Network/virtualNetworks/vnet-example/subnets/ExampleSubnet"
    ]
  }
}
```

> [!Note]
> In this scenario the `ExampleSubnet` would need to be configured with a service endpoint for `Microsoft.KeyVault`.

#### Enable Public Endpoint without Restriction

```hcl
module "key_vault" {
  source  = "AscentSoftware/key-vault/azurerm"
  version = "1.0.0"

  location            = "uksouth"
  resource_group_name = "rg-example"

  enable_public_access = true
  network_access = {
    default_action = "Allow"
  }
}
```

> [!Warning]
> While still protected through identity, enabling public access without restriction is not a recommended configuration.

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
| [azurerm_monitor_diagnostic_setting.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [random_integer.resource_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [random_pet.resource_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The region into which resources will be deployed. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group into which resources will be deployed. | `string` | n/a | yes |
| <a name="input_delete_retention_days"></a> [delete\_retention\_days](#input\_delete\_retention\_days) | The number of days to retain soft-deleted keys, secrets, and certificates. | `number` | `7` | no |
| <a name="input_diagnostics"></a> [diagnostics](#input\_diagnostics) | An object used to define diagnostic settings for resources, in the format:<pre>{<br/>  key_vault = {<br/>    default = {<br/>      log_analytics_workspace_id     = "/subscriptions/.../providers/Microsoft.OperationalInsights/workspaces/log-example"<br/>      log_analytics_destination_type = "AzureDiagnostics"<br/>      log_categories                 = ["AuditEvent"]<br/>    }<br/>  }<br/>}</pre> | <pre>object({<br/>    key_vault = optional(map(object({<br/>      log_analytics_workspace_id     = string<br/>      log_analytics_destination_type = optional(string, "AzureDiagnostics")<br/>      log_categories                 = optional(list(string), ["AuditEvent"])<br/>      metric_categories              = optional(list(string), ["AllMetrics"])<br/>    })), {})<br/>  })</pre> | `{}` | no |
| <a name="input_enable_for_deployment"></a> [enable\_for\_deployment](#input\_enable\_for\_deployment) | Determines if virtual machines can retrieve secrets from the key vault during deployment. | `bool` | `false` | no |
| <a name="input_enable_for_disk_encryption"></a> [enable\_for\_disk\_encryption](#input\_enable\_for\_disk\_encryption) | Determines if the Azure disk encryption service can retrieve secrets from the key vault. | `bool` | `false` | no |
| <a name="input_enable_for_template_deployment"></a> [enable\_for\_template\_deployment](#input\_enable\_for\_template\_deployment) | Determines if Azure Resource Manager can retrieve secrets from the key vault during template deployment. | `bool` | `false` | no |
| <a name="input_enable_public_access"></a> [enable\_public\_access](#input\_enable\_public\_access) | Determines if public network access should be enabled. | `bool` | `false` | no |
| <a name="input_network_access"></a> [network\_access](#input\_network\_access) | An object used to define network access to key vault, in the format:<pre>{<br/>  bypass         = "AzureServices"<br/>  default_action = "Deny"<br/>  ip_rules = [<br/>    "80.170.100.82/32",<br/>    "80.170.101.0/24"<br/>  ]<br/>  virtual_network_subnet_ids = [<br/>    "/subscriptions/.../providers/Microsoft.Network/virtualNetworks/vnet-example/subnets/ExampleSubnet"<br/>  ]<br/>}</pre>Subnets defined in `virtual_network_subnet_ids` should be configured with service endpoint for `Microsoft.KeyVault`. | <pre>object({<br/>    bypass                     = optional(string, "AzureServices")<br/>    default_action             = optional(string, "Deny")<br/>    ip_rules                   = optional(list(string))<br/>    virtual_network_subnet_ids = optional(list(string))<br/>  })</pre> | <pre>{<br/>  "bypass": "AzureServices",<br/>  "default_action": "Deny"<br/>}</pre> | no |
| <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name) | An object used to define explicit resource names, in the format:<pre>{<br/>  key_vault = "kv-example-123"<br/>}</pre>Resource names will be randomly generated if not provided. | <pre>object({<br/>    key_vault = optional(string, null)<br/>  })</pre> | `{}` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | A map of key-value pairs to use as resource tags. | `map(string)` | `null` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The key vault SKU to provision. | `string` | `"Standard"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | The ID of the key vault. |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | The name of the key vault. |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | The URI of the key vault. |
<!-- END_TF_DOCS -->
