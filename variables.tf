variable "alert" {
  default     = {}
  description = <<-EOT
  An object used to define alerts for resources, in the format:
  ```
  {
    key_vault = {
      availability = {
        action_group_id     = "/subscriptions/.../resourceGroups/rg-example/providers/Microsoft.Insights/actionGroups/ag-example"
        alert_name          = "kv-example-Availability"
        enabled             = true
        resource_group_name = "rg-alerts-example"
        severity            = 3
        threshold           = 95
      }
      saturation                    = { ... }
      service_api_hit               = { ... }
      service_api_latency           = { ... }
      service_api_result_anomaly    = { ... }
      service_api_result_rate_limit = { ... }
    }
  }
  ```
  The default action group for all alerts can be set using the `action_group_id` attribute.
  Action groups defined per alert will override the default action group.
  Either the default `action_group_id` or an `action_group_id` per alert must be provided.
  EOT
  type = object({
    action_group_id = optional(string)
    key_vault = optional(object({
      availability = optional(object({
        action_group_id     = optional(string, null)
        alert_name          = optional(string)
        enabled             = optional(bool, true)
        resource_group_name = optional(string)
        severity            = optional(number, 1)
        tags                = optional(map(string))
        threshold           = optional(number, 90)
      }), {})
      deleted = optional(object({
        action_group_id     = optional(string, null)
        alert_name          = optional(string)
        enabled             = optional(bool, true)
        resource_group_name = optional(string)
        statuses            = optional(list(string), ["Succeeded"])
        tags                = optional(map(string))
      }), {})
      saturation = optional(object({
        action_group_id     = optional(string, null)
        alert_name          = optional(string)
        enabled             = optional(bool, true)
        resource_group_name = optional(string)
        severity            = optional(number, 3)
        tags                = optional(map(string))
        threshold           = optional(number, 75)
      }), {})
      service_api_hit = optional(object({
        action_group_id     = optional(string, null)
        alert_name          = optional(string)
        enabled             = optional(bool, true)
        resource_group_name = optional(string)
        severity            = optional(number, 3)
        tags                = optional(map(string))
        threshold           = optional(number, 80)
      }), {})
      service_api_latency = optional(object({
        action_group_id     = optional(string, null)
        alert_name          = optional(string)
        enabled             = optional(bool, true)
        resource_group_name = optional(string)
        severity            = optional(number, 3)
        tags                = optional(map(string))
        threshold           = optional(number, 1000)
      }), {})
      service_api_result_anomaly = optional(object({
        action_group_id     = optional(string, null)
        alert_name          = optional(string)
        enabled             = optional(bool, true)
        resource_group_name = optional(string)
        severity            = optional(number, 3)
        sensitivity         = optional(string, "Medium")
        tags                = optional(map(string))
      }), {})
      service_api_result_rate_limit = optional(object({
        action_group_id     = optional(string, null)
        alert_name          = optional(string)
        enabled             = optional(bool, true)
        resource_group_name = optional(string)
        severity            = optional(number, 3)
        tags                = optional(map(string))
      }), {})
    }), {})
  })
}

variable "delete_retention_days" {
  default     = 7
  description = "The number of days to retain soft-deleted keys, secrets, and certificates."
  type        = number

  validation {
    condition     = var.delete_retention_days >= 7 && var.delete_retention_days <= 90
    error_message = "Soft delete retention must be set to between 7 and 90 days."
  }
}

variable "diagnostics" {
  default     = {}
  description = <<-EOT
  An object used to define diagnostic settings for resources, in the format:
  ```
  {
    key_vault = {
      default = {
        log_analytics_workspace_id     = "/subscriptions/.../providers/Microsoft.OperationalInsights/workspaces/log-example"
        log_analytics_destination_type = "AzureDiagnostics"
        log_categories                 = ["AuditEvent"]
      }
    }
  }
  ```
  EOT
  type = object({
    key_vault = optional(map(object({
      log_analytics_workspace_id     = string
      log_analytics_destination_type = optional(string, "AzureDiagnostics")
      log_categories                 = optional(list(string), ["AuditEvent"])
      metric_categories              = optional(list(string), ["AllMetrics"])
    })), {})
  })
}

variable "enable_for_deployment" {
  default     = false
  description = "Determines if virtual machines can retrieve secrets from the key vault during deployment."
  type        = bool
}

variable "enable_for_disk_encryption" {
  default     = false
  description = "Determines if the Azure disk encryption service can retrieve secrets from the key vault."
  type        = bool
}

variable "enable_for_template_deployment" {
  default     = false
  description = "Determines if Azure Resource Manager can retrieve secrets from the key vault during template deployment."
  type        = bool
}

variable "enable_public_access" {
  default     = false
  description = "Determines if public network access should be enabled."
  type        = bool
}

variable "location" {
  description = "The region into which resources will be deployed."
  type        = string
}

variable "network_access" {
  default = {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
  description = <<-EOT
  An object used to define network access to key vault, in the format:
  ```
  {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules = [
      "80.170.100.82/32",
      "80.170.101.0/24"
    ]
    virtual_network_subnet_ids = [
      "/subscriptions/.../providers/Microsoft.Network/virtualNetworks/vnet-example/subnets/ExampleSubnet"
    ]
  }
  ```
  Subnets defined in `virtual_network_subnet_ids` should be configured with service endpoint for `Microsoft.KeyVault`.
  EOT
  type = object({
    bypass                     = optional(string, "AzureServices")
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
  })
}

variable "private_endpoint" {
  default     = {}
  description = <<-EOT
  An object used to define private endpoints for resources, in the format:
  ```
  {
    key_vault = {
      vault = {
        private_dns_zone_ids = [
          "/subscriptions/.../providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
        ]
        subnet_id = "/subscriptions/.../providers/Microsoft.Network/virtualNetworks/vnet-example/subnets/ExampleSubnet"
      }
    }
  }
  ```
  EOT
  type = object({
    key_vault = optional(map(object({
      private_dns_zone_ids   = list(string)
      subnet_id              = string
      endpoint_name          = optional(string)
      network_interface_name = optional(string)
      resource_group_name    = optional(string)
      tags                   = optional(map(string))
    })), {})
  })
}

variable "resource_group_name" {
  description = "The resource group into which resources will be deployed."
  type        = string
}

variable "resource_name" {
  default     = {}
  description = <<-EOT
  An object used to define explicit resource names, in the format:
  ```
  {
    key_vault = "kv-example-123"
  }
  ```
  Resource names will be randomly generated if not provided.
  EOT
  type = object({
    key_vault = optional(string, null)
  })

  validation {
    condition = (
      can(regex("^[a-zA-Z](?:[0-9a-zA-Z-]{1,22})?[0-9a-zA-Z]$", var.resource_name.key_vault)) ||
      var.resource_name.key_vault == null
    )
    error_message = <<-EOT
    Key vault name must meet the following criteria:
    - Have a length of 3-24 characters;
    - Contain only alphanumerics and hyphens;
    - Start with a letter;
    - End with a digit or letter;
    - Not contain consecutive hyphens.
    EOT
  }
}

variable "resource_tags" {
  default     = null
  description = "A map of key-value pairs to use as resource tags."
  type        = map(string)
}

variable "role_assignments" {
  default     = {}
  description = <<-EOT
  An object used to define role assignments for resources, in the format:
  ```
  {
    key_vault = {
      service_principal_key_vault_administrator = {
        principal_id                 = "0000000000-0000-0000-0000-000000000001"
        principal_type               = "ServicePrincipal"
        role_definition_name         = "Key Vault Administrator"
        skip_service_principal_check = true
      }
    }
  }
  ```
  EOT
  type = object({
    key_vault = optional(map(object({
      principal_id                 = string
      role_definition_name         = string
      description                  = optional(string)
      principal_type               = optional(string, "Group")
      skip_service_principal_check = optional(bool, false)
    })), {})
  })
}

variable "sku" {
  default     = "Standard"
  description = "The key vault SKU to provision."
  type        = string

  validation {
    condition     = contains(["Standard", "Premium"], var.sku)
    error_message = "Key vault SKU must be one of \"Standard\", or \"Premium\"."
  }
}
