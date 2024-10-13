output "action_group_id" {
  description = "The ID of the action group."
  value       = azurerm_monitor_action_group.terraform_test.id
}

output "deployment_object_id" {
  description = "The object ID of the deployment principal."
  value       = data.azurerm_client_config.context.object_id
}

output "location" {
  description = "The location of the resources."
  value       = var.location
}

output "log_analytics_workspace_id" {
  description = "The ID of the log analytics workspace."
  value       = azurerm_log_analytics_workspace.terraform_test.id
}

output "private_dns_zone_ids" {
  description = "An object mapping private DNS zones to IDs."
  value = {
    key_vault = {
      vault = azurerm_private_dns_zone.privatelink_vaultcore_azure_net.id
    }
  }
}

output "resource_group_name" {
  description = "The name of the resource group."
  value       = azurerm_resource_group.terraform_test.name
}

output "subnet_ids" {
  description = "An object mapping subnets to IDs."
  value = {
    private_endpoint = azurerm_subnet.private_endpoints.id
    service_endpoint = azurerm_subnet.service_endpoints.id
  }
}
