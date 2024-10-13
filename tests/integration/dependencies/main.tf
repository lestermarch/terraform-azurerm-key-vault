terraform {
  required_version = "~> 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Deployment context
data "azurerm_client_config" "context" {}

# Random string and integer for resource naming
resource "random_pet" "resource_suffix" {}

resource "random_integer" "entropy" {
  min = 100
  max = 999
}

# Temporary network resources for Terraform integration tests
resource "azurerm_resource_group" "terraform_test" {
  name     = local.resource_name.resource_group
  location = var.location
}

resource "azurerm_virtual_network" "terraform_test" {
  name                = local.resource_name.virtual_network
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform_test.name

  address_space = ["10.24.0.0/24"]
}

resource "azurerm_subnet" "private_endpoints" {
  name                = "PrivateEndpointSubnet"
  resource_group_name = azurerm_resource_group.terraform_test.name

  address_prefixes     = ["10.24.0.0/26"]
  virtual_network_name = azurerm_virtual_network.terraform_test.name
}

resource "azurerm_subnet" "service_endpoints" {
  name                = "ServiceEndpointSubnet"
  resource_group_name = azurerm_resource_group.terraform_test.name

  address_prefixes     = ["10.24.0.64/26"]
  service_endpoints    = ["Microsoft.KeyVault"]
  virtual_network_name = azurerm_virtual_network.terraform_test.name
}

resource "azurerm_private_dns_zone" "privatelink_vaultcore_azure_net" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.terraform_test.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_vaultcore_azure_net" {
  name                = azurerm_private_dns_zone.privatelink_vaultcore_azure_net.name
  resource_group_name = azurerm_resource_group.terraform_test.name

  private_dns_zone_name = azurerm_private_dns_zone.privatelink_vaultcore_azure_net.name
  virtual_network_id    = azurerm_virtual_network.terraform_test.id
}

# Temporary logging resources for Terraform integration tests
resource "azurerm_log_analytics_workspace" "terraform_test" {
  name                = local.resource_name.log_analytics_workspace
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform_test.name

  sku = "PerGB2018"
}

# Temporary alerting resources for Terraform integration tests
resource "azurerm_monitor_action_group" "terraform_test" {
  name                = local.resource_name.action_group
  resource_group_name = azurerm_resource_group.terraform_test.name

  enabled    = false
  short_name = "tftest"

  email_receiver {
    name          = "Lester March"
    email_address = "lester.march@ascent.io"
  }
}
