mock_provider "azurerm" {
  source = "./tests/unit"
}

variables {
  location            = "uksouth"
  resource_group_name = "rg-mock"
  resource_name       = {
    key_vault = "kv-mock"
  }
}

run "default_configuration" {
  command = plan

  variables {
    private_endpoint = {
      key_vault = {
        vault = {
          private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
          subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/virtualNetworks/vnet-mock/subnets/MockSubnet"
        }
      }
    }
  }

  # Private endpoint name
  assert {
    condition     = azurerm_private_endpoint.key_vault["vault"].name == "kv-mock-pe-vault"
    error_message = "Private endpoint should have the name kv-mock-vault."
  }

  # Automatic approval
  assert {
    condition     = azurerm_private_endpoint.key_vault["vault"].private_service_connection[0].is_manual_connection == false
    error_message = "Private endpoint should not require manual approval."
  }

  # Target resource ID
  assert {
    condition     = azurerm_private_endpoint.key_vault["vault"].private_service_connection[0].subresource_names[0] == "vault"
    error_message = "Private endpoint should target the vault subresource."
  }
}

run "alternative_endpoint_name" {
  command = plan

  variables {
    private_endpoint = {
      key_vault = {
        vault = {
          private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
          subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/virtualNetworks/vnet-mock/subnets/MockSubnet"
          endpoint_name        = "pe-vault-kv-mock"
        }
      }
    }
  }

  # Private endpoint name
  assert {
    condition     = azurerm_private_endpoint.key_vault["vault"].name == "pe-vault-kv-mock"
    error_message = "Private endpoint should have the name pe-vault-kv-mock."
  }
}

run "alternative_resource_group_name" {
  command = plan

  variables {
    private_endpoint = {
      key_vault = {
        vault = {
          private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
          subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/virtualNetworks/vnet-mock/subnets/MockSubnet"
          resource_group_name  = "rg-endpoint-mock"
        }
      }
    }
  }

  # Key vault resource group name
  assert {
    condition     = azurerm_key_vault.main.resource_group_name == "rg-mock"
    error_message = "Key vault should be in the rg-mock resource group."
  }

  # Private endpoint resource group name
  assert {
    condition     = azurerm_private_endpoint.key_vault["vault"].resource_group_name == "rg-endpoint-mock"
    error_message = "Private endpoint should be in the rg-endpoint-mock resource group."
  }
}

run "alternative_resource_tags" {
  command = plan

  variables {
    private_endpoint = {
      key_vault = {
        vault = {
          private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
          subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/virtualNetworks/vnet-mock/subnets/MockSubnet"
          tags = {
            environment = "override"
          }
        }
      }
    }
    resource_tags = {
      environment = "mock"
    }
  }

  # Key vault tags
  assert {
    condition     = azurerm_key_vault.main.tags["environment"] == "mock"
    error_message = "Key vault should have the environment tag set to mock."
  }

  # Private endpoint tags
  assert {
    condition     = azurerm_private_endpoint.key_vault["vault"].tags["environment"] == "override"
    error_message = "Private endpoint should have the environment tag set to override."
  }
}
