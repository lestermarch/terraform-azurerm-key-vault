mock_provider "azurerm" {
  source = "./tests/unit"
}

variables {
  location            = "uksouth"
  resource_group_name = "rg-mock"
  resource_names      = {
    key_vault = "kv-mock"
  }
}

run "entra_id_group_assignment" {
  command = plan

  variables {
    role_assignments = {
      key_vault = {
        entra_id_group_test = {
          description                  = "Entra ID group assignment"
          principal_id                 = "00000000-0000-0000-0000-000000000000"
          principal_type               = "Group"
          role_definition_name         = "Reader"
        }
      }
    }
  }

  # Role assignment description
  assert {
    condition     = azurerm_role_assignment.key_vault["entra_id_group_test"].description == "Entra ID group assignment"
    error_message = "Role assignment should have the correct description."
  }

  # Role assignment principal ID
  assert {
    condition     = azurerm_role_assignment.key_vault["entra_id_group_test"].principal_id == "00000000-0000-0000-0000-000000000000"
    error_message = "Role assignment should have the correct principal ID."
  }

  # Role assignment principal type
  assert {
    condition     = azurerm_role_assignment.key_vault["entra_id_group_test"].principal_type == "Group"
    error_message = "Role assignment should have the correct principal type."
  }

  # Role assignment definition name
  assert {
    condition     = azurerm_role_assignment.key_vault["entra_id_group_test"].role_definition_name == "Reader"
    error_message = "Role assignment should have the correct role definition name."
  }
}

run "entra_id_user_assignment" {
  command = plan

  variables {
    role_assignments = {
      key_vault = {
        entra_id_user_test = {
          description                  = "Entra ID user assignment"
          principal_id                 = "00000000-0000-0000-0000-000000000001"
          principal_type               = "User"
          role_definition_name         = "Key Vault Secrets Officer"
        }
      }
    }
  }

  # Role assignment description
  assert {
    condition     = azurerm_role_assignment.key_vault["entra_id_user_test"].description == "Entra ID user assignment"
    error_message = "Role assignment should have the correct description."
  }

  # Role assignment principal ID
  assert {
    condition     = azurerm_role_assignment.key_vault["entra_id_user_test"].principal_id == "00000000-0000-0000-0000-000000000001"
    error_message = "Role assignment should have the correct principal ID."
  }

  # Role assignment principal type
  assert {
    condition     = azurerm_role_assignment.key_vault["entra_id_user_test"].principal_type == "User"
    error_message = "Role assignment should have the correct principal type."
  }

  # Role assignment definition name
  assert {
    condition     = azurerm_role_assignment.key_vault["entra_id_user_test"].role_definition_name == "Key Vault Secrets Officer"
    error_message = "Role assignment should have the correct role definition name."
  }
}

run "entra_id_service_principal_assignment" {
  command = plan

  variables {
    role_assignments = {
      key_vault = {
        entra_id_service_principal_test = {
          description                  = "Entra ID service principal assignment"
          principal_id                 = "00000000-0000-0000-0000-000000000002"
          principal_type               = "ServicePrincipal"
          role_definition_name         = "Key Vault Crypto Officer"
          skip_service_principal_check = true
        }
      }
    }
  }

  # Role assignment description
  assert {
    condition     = azurerm_role_assignment.key_vault["entra_id_service_principal_test"].description == "Entra ID service principal assignment"
    error_message = "Role assignment should have the correct description."
  }

  # Role assignment principal ID
  assert {
    condition     = azurerm_role_assignment.key_vault["entra_id_service_principal_test"].principal_id == "00000000-0000-0000-0000-000000000002"
    error_message = "Role assignment should have the correct principal ID."
  }

  # Role assignment principal type
  assert {
    condition     = azurerm_role_assignment.key_vault["entra_id_service_principal_test"].principal_type == "ServicePrincipal"
    error_message = "Role assignment should have the correct principal type."
  }

  # Role assignment definition name
  assert {
    condition     = azurerm_role_assignment.key_vault["entra_id_service_principal_test"].role_definition_name == "Key Vault Crypto Officer"
    error_message = "Role assignment should have the correct role definition name."
  }

  # Role assignment skip service principal AAD check
  assert {
    condition     = azurerm_role_assignment.key_vault["entra_id_service_principal_test"].skip_service_principal_aad_check == true
    error_message = "Role assignment should skip the service principal AAD check."
  }
}
