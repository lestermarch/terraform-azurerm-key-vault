provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

variables {
  location = "uksouth"
}

run "create_dependencies" {
  command = apply

  module {
    source = "./tests/integration/dependencies"
  }
}

run "default_configuration" {
  command = apply

  variables {
    resource_group_name = run.create_dependencies.resource_group_name
  }
}

run "enable_alerts" {
  command = apply

  variables {
    alert = {
      action_group_id = run.create_dependencies.action_group_id
    }

    resource_group_name = run.create_dependencies.resource_group_name
  }
}

run "enable_diagnostics" {
  command = apply

  variables {
    resource_group_name = run.create_dependencies.resource_group_name
    diagnostics = {
      key_vault = {
        diagnostics = {
          log_analytics_workspace_id = run.create_dependencies.log_analytics_workspace_id
        }
      }
    }
  }
}

run "enable_private_endpoint" {
  command = apply

  variables {
    resource_group_name = run.create_dependencies.resource_group_name
    private_endpoint = {
      key_vault = {
        vault = {
          private_dns_zone_ids = [run.create_dependencies.private_dns_zone_ids.key_vault.vault]
          subnet_id            = run.create_dependencies.subnet_ids.private_endpoint
        }
      }
    }
  }
}

run "enable_role_based_access_control" {
  command = apply

  variables {
    resource_group_name = run.create_dependencies.resource_group_name
    role_assignments = {
      key_vault = {
        deployment_context_key_vault_administrator = {
          description          = "Terraform Test"
          principal_id         = run.create_dependencies.deployment_object_id
          principal_type       = "User"
          role_definition_name = "Key Vault Administrator"
        }
      }
    }
  }
}

run "enable_service_endpoint" {
  command = apply

  variables {
    enable_public_access = true
    resource_group_name  = run.create_dependencies.resource_group_name
    network_access = {
      virtual_network_subnet_ids = [run.create_dependencies.subnet_ids.service_endpoint]
    }
  }
}
