# terraform-azurerm-app-config

Creates an Azure App Configuration store with optional RBAC role assignments on it.

Part of the [Raring Group](https://github.com/raringgroup) Terraform module library.

## Usage

```hcl
module "app_config" {
  source = "git::https://github.com/raringgroup/terraform-azurerm-app-config.git?ref=v0.1.0"

  context = module.context.self

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

Naming and tagging come from [`terraform-null-context`](https://github.com/raringgroup/terraform-null-context). Add `_context.tf` to the calling configuration and pass `context = module.context.self`.

See [`examples/`](examples/) for complete, runnable configurations.

## Module Priority

The module uses `azurerm_app_configuration` and `azurerm_role_assignment` directly. The store name is limited to 50 characters, the Azure maximum. `_context.tf` declares the root context; it and the child contexts use `git::https://github.com/raringgroup/terraform-null-context.git?ref=v0.1.0`. Configuration keys and feature flags are not managed here.

## Naming

The store name is built by the Raring Group context module from the context inputs plus the type token `appcfg`. These inputs produce `appcfg-dev-example-app-eus001`:

```hcl
inputs = {
  namespace   = "example"
  environment = "dev"
  name        = "app"
  region      = "eus001"
  label_order = ["attributes", "environment", "namespace", "name", "region"]
}
```

## Requirements, providers, inputs, outputs

### Requirements

| Name | Version |
|------|---------|
| terraform | `>= 1.3.0` |
| azurerm | `>= 4.0.0, < 5.0.0` |

### Inputs

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

### Outputs

| Name | Description |
|------|-------------|
| id | Store ID (null when disabled) |
| name | Store name (null when disabled) |
| endpoint | Store endpoint (null when disabled) |

## Versioning

Releases follow semantic versioning and are tagged `vX.Y.Z`. Pin `?ref=` to a tag.

## Contributing

Work happens on `develop` through feature branches and pull requests. See the Raring Group gitflow standards.

## License

Apache-2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE).

`_context.tf` is derived from the upstream [cloudposse/terraform-null-label](https://github.com/cloudposse/terraform-null-label) module by Cloud Posse, LLC.
