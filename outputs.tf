output "key_vault_id" {
  description = "The ID of the key vault."
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "The name of the key vault."
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "The URI of the key vault."
  value       = azurerm_key_vault.main.vault_uri
}
