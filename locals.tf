locals {
  # Generate a name for resources if not provided
  resource_name = {
    key_vault = coalesce(var.resource_name.key_vault, "kv-${local.resource_suffix}")
  }

  # Generated resource suffix for randomized resource names
  resource_suffix = "${random_pet.resource_suffix.id}-${random_integer.resource_suffix.id}"
}
