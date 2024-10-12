terraform {
  required_version = "~> 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Deployment context
data "azurerm_client_config" "context" {}

# Resource name entropy
resource "random_pet" "resource_suffix" {}

resource "random_integer" "resource_suffix" {
  max = 999
  min = 100
}
