# Enabling and Configuring Public Network Access

This module disables public access by default, but offers an interface to enable and configure this as required through the `enable_public_access` and `network_access` variable.

> [!Tip]
> To provide access securely from Azure resources, consider configuring [private access](/docs/example-usage-private-access.md) through a private endpoint, or public access through [service endpoints](#12-enable-public-network-access-with-service-endpoint). Public and private endpoints are not mutually exclusive, and can be deployed together if required.

## 1.1. Enable public network access with firewall

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = "2024-10-12"

  location            = "uksouth"
  resource_group_name = "rg-example"

  enable_public_access = true
  network_access = {
    ip_rules = [
      "80.170.100.82/32",
      "80.170.101.0/24"
    ]
  }
}
```

## 1.2. Enable public network access with service endpoint

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = "2024-10-12"

  location            = "uksouth"
  resource_group_name = "rg-example"

  enable_public_access = true
  network_access = {
    virtual_network_subnet_ids = [
      "/subscriptions/.../providers/Microsoft.Network/virtualNetworks/vnet-example/subnets/ExampleSubnet"
    ]
  }
}
```

> [!Note]
> In this scenario the `ExampleSubnet` would need to be configured with a service endpoint for `Microsoft.KeyVault`.

## 1.3. Enable unrestricted public network access

```hcl
module "key_vault" {
  source  = "lestermarch/key-vault/azurerm"
  version = "1.0.0"

  location            = "uksouth"
  resource_group_name = "rg-example"

  enable_public_access = true
  network_access = {
    default_action = "Allow"
  }
}
```

> [!Warning]
> While still protected through identity, enabling public access without restriction is not a recommended configuration.
