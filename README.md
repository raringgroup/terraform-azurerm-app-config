# app-config

Creates an Azure App Configuration store with optional RBAC role assignments on it, named through the `null-context` module.

## Requirements

| Name | Version |
|------|---------|
| terraform | `>= 1.3.0` |
| azurerm | `>= 4.0.0, < 5.0.0` |

## Module Priority

No SevenPico, SevenPicoForks or CloudPosse module exists for Azure App Configuration, so the module uses `azurerm_app_configuration` and `azurerm_role_assignment` directly. The store name is limited to 50 characters, the Azure maximum. `_context.tf` declares the root context; it and the child contexts use `git::https://github.com/raringgroup/terraform-null-context.git?ref=v0.1.0`. Configuration keys and feature flags are not managed here.

## Naming

The store name is built by `null-context` from the context inputs plus the type token `appcfg`. These inputs produce `appcfg-dev-upsis-ehssync-eus001`:

```hcl
inputs = {
  namespace   = "upsis"
  environment = "dev"
  name        = "ehssync"
  region      = "eus001"
  label_order = ["attributes", "environment", "namespace", "name", "region"]
}
```

## Inputs

All inputs are required (no defaults). Context inputs (`enabled`, `namespace`, `environment`, `stage`, `name`, `attributes`, `tags`, ...) are declared in `_context.tf`.

| Name | Type | Description |
|------|------|-------------|
| resource_group_name | `string` | Resource group that holds the store |
| location | `string` | Azure region |
| sku | `string` | `free`, `developer`, `standard` or `premium`; purge protection and soft delete work only on `standard` |
| local_auth_enabled | `bool` | Access-key authentication; `false` limits access to Microsoft Entra ID |
| public_network_access | `string` | `Enabled` or `Disabled`. `null` leaves it Automatic, which cannot be restored once a value is set |
| purge_protection_enabled | `bool` | Purge protection (`standard` only) |
| soft_delete_retention_days | `number` | Days a deleted store is retained, 1 to 7 (`standard` only; changing it forces a new store) |
| role_assignments | `map(object)` | RBAC assignments on the store: `principal_id`, `role_definition_name` |

## Outputs

| Name | Description |
|------|-------------|
| id | Store ID (null when disabled) |
| name | Store name (null when disabled) |
| endpoint | Store endpoint (null when disabled) |

## Usage

```hcl
terraform {
  source = "git::https://github.com/raringgroup/terraform-azurerm-app-config.git?ref=develop"
}

inputs = {
  enabled     = true
  namespace   = "<namespace>"
  environment = "<environment>"
  name        = "<name>"
  region      = "<region-code>"
  label_order = ["attributes", "environment", "namespace", "name", "region"]

  local_auth_enabled         = false
  location                   = "<azure-region>"
  public_network_access      = "Enabled"
  purge_protection_enabled   = false
  resource_group_name        = "<resource-group>"
  sku                        = "standard"
  soft_delete_retention_days = 7

  role_assignments = {
    "app-data-reader" = {
      principal_id         = "<principal-id>"
      role_definition_name = "App Configuration Data Reader"
    }
  }
}
```

## License

Apache License 2.0. Copyright 2026 Raring Group LLC.
