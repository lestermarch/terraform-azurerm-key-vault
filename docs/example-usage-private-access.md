# Enabling and Configuring Private Network Access

This module disables public access by default. To configure private access, a private endpoint must be configured through the `private_endpoint` variable.

## 1.1. Provision a single private endpoint

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = "2024-10-12"

  location            = "uksouth"
  resource_group_name = "rg-example"

  private_endpoints = {
    key_vault = {
      vault = {
        private_dns_zone_ids = [
          "/subscriptions/.../providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
        ]
        subnet_id = "/subscriptions/.../providers/Microsoft.Network/virtualNetworks/vnet-example/subnets/ExampleSubnet"
      }
    }
  }
}
```

> [!Note]
> In the case of Key Vault, there is only a single `vault` subresource to target for private connectivity. This is denoted by the map key for the private endpoint configuration object.
