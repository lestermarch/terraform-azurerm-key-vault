# Enabling and Configuring Role Assignments

This module support role assignments through Azure RBAC. This can be useful for assigning data plane permissions at deployment time. Role assignments can be provided through the `role_assignment` variable.

## 1.1. Assign an Entra ID group with the Key Vault Secrets Officer role

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = "2024-10-12"

  location            = "uksouth"
  resource_group_name = "rg-example"

  role_assignments = {
    key_vault = {
      example_group_key_vault_secrets_officer = {
        description          = "Example group role assignment"
        principal_id         = "00000000-0000-0000-0000-000000000001"
        role_definition_name = "Key Vault Secrets Officer"
      }
    }
  }
}
```

> [!Note]
> The default `principal_type` is set to `Group`, as it is often recommended to use Entra ID groups for access rather than individual users.

# 1.2. Assign multiple roles to multiple identity types

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = "2024-10-12"

  location            = "uksouth"
  resource_group_name = "rg-example"

  role_assignments = {
    key_vault = {
      example_user_key_vault_administrator = {
        description          = "Example user role assignment"
        principal_id         = "00000000-0000-0000-0000-000000000001"
        principal_type       = "User"
        role_definition_name = "Key Vault Administrator"
      }
      example_service_principal_key_vault_secrets_user = {
        description          = "Example service principal role assignment"
        principal_id         = "00000000-0000-0000-0000-000000000002"
        principal_type       = "ServicePrincipal"
        role_definition_name = "Key Vault Secrets User"
      }
    }
  }
}
```
