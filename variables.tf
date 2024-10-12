variable "delete_retention_days" {
  default     = 7
  description = "The number of days to retain soft-deleted keys, secrets, and certificates."
  type        = number

  validation {
    condition     = var.delete_retention_days >= 7 && var.delete_retention_days <= 90
    error_message = "Soft delete retention must be set to between 7 and 90 days."
  }
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

variable "sku" {
  default     = "Standard"
  description = "The key vault SKU to provision."
  type        = string

  validation {
    condition     = contains(["Standard", "Premium"], var.sku)
    error_message = "Key vault SKU must be one of \"Standard\", or \"Premium\"."
  }
}
