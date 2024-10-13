mock_provider "azurerm" {
  source = "./tests/unit"
}

variables {
  location            = "uksouth"
  resource_group_name = "rg-terraform-test"
}

run "default_configuration" {
  command = plan

  # Key vault purge protection
  assert {
    condition     = azurerm_key_vault.main.purge_protection_enabled == true
    error_message = "Key vault should have purge protection should be enabled."
  }

  # Key vault soft delete retention
  assert {
    condition     = (
      azurerm_key_vault.main.soft_delete_retention_days >= 7 &&
      azurerm_key_vault.main.soft_delete_retention_days <= 90
    )
    error_message = "Key vault should have soft delete retention set to between 7 and 90 days."
  }

  # Key vault network access
  assert {
    condition     = azurerm_key_vault.main.public_network_access_enabled == false
    error_message = "Key vault should have public network access disabled."
  }

  assert {
    condition     = azurerm_key_vault.main.network_acls[0].bypass == "AzureServices"
    error_message = "Key vault should have Azure services bypassed."
  }

  assert {
    condition     = azurerm_key_vault.main.network_acls[0].default_action == "Deny"
    error_message = "Key vault should deny all network traffic by default."
  }
}

run "alternative_resource_name" {
  command = plan

  variables {
    resource_name = {
      key_vault = "kv-terraform-test"
    }
  }

  # Key vault name
  assert {
    condition     = azurerm_key_vault.main.name == "kv-terraform-test"
    error_message = "Key vault should have the correct name."
  }
}

run "alternative_resource_tags" {
  command = plan

  variables {
    resource_tags = {
      environment = "test"
      cost_center = "12345"
    }
  }

  # Key vault tags
  assert {
    condition     = contains(keys(azurerm_key_vault.main.tags), "environment")
    error_message = "Key vault should have the correct environment tag."
  }

  assert {
    condition     = contains(values(azurerm_key_vault.main.tags), "test")
    error_message = "Key vault should have the correct environment tag value."
  }

  assert {
    condition     = contains(keys(azurerm_key_vault.main.tags), "cost_center")
    error_message = "Key vault should have the correct cost center tag."
  }

  assert {
    condition     = contains(values(azurerm_key_vault.main.tags), "12345")
    error_message = "Key vault should have the correct cost center tag value."
  }
}

run "alternative_sku" {
  command = plan

  # Key vault SKU
  variables {
    sku = "Premium"
  }

  assert {
    condition     = azurerm_key_vault.main.sku_name == "premium"
    error_message = "Key vault should have the correct SKU."
  }
}

run "public_network_access_with_firewall" {
  command = plan

  variables {
    enable_public_access = true
    network_access = {
      default_action = "Deny"
      ip_rules       = ["20.56.154.96"]
    }
  }

  # Key vault public access
  assert {
    condition     = azurerm_key_vault.main.public_network_access_enabled == true
    error_message = "Key vault should have public network access enabled."
  }

  # Key vault network access
  assert {
    condition     = azurerm_key_vault.main.network_acls[0].default_action == "Deny"
    error_message = "Key vault should deny all network traffic by default."
  }

  assert {
    condition     = contains([for rule in azurerm_key_vault.main.network_acls[0].ip_rules : rule], "20.56.154.96")
    error_message = "Key vault should have the correct IP rule."
  }
}

run "public_network_access_with_service_endpoint" {
  command = plan

  variables {
    enable_public_access = true
    network_access = {
      default_action             = "Deny"
      virtual_network_subnet_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/virtualNetworks/vnet-mock/subnets/subnet-mock"]
    }
  }

  # Key vault public access
  assert {
    condition     = azurerm_key_vault.main.public_network_access_enabled == true
    error_message = "Key vault should have public network access enabled."
  }

  # Key vault network access
  assert {
    condition     = azurerm_key_vault.main.network_acls[0].default_action == "Deny"
    error_message = "Key vault should deny all network traffic by default."
  }

  assert {
    condition     = contains([for subnet in azurerm_key_vault.main.network_acls[0].virtual_network_subnet_ids : subnet], "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/virtualNetworks/vnet-mock/subnets/subnet-mock")
    error_message = "Key vault should have the correct virtual network subnet ID."
  }
}
