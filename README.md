# app-config

Creates an Azure App Configuration store with optional RBAC role assignments on it, named through the SevenPico context module.

## Requirements

| Name | Version |
|------|---------|
| terraform | `>= 1.3.0` |
| azurerm | `>= 4.0.0, < 5.0.0` |

## Module Priority

No SevenPico, SevenPicoForks or CloudPosse module exists for Azure App Configuration, so the module uses `azurerm_app_configuration` and `azurerm_role_assignment` directly. The store name is limited to 50 characters, the Azure maximum. Naming and the enabled flag come from the context module. `_context.tf` declares the root context (`SevenPico/context/null` `2.0.0`); child contexts use the local `../null-context` module. Configuration keys and feature flags are not managed here.

## Inputs

All inputs are required (no defaults). Context inputs (`enabled`, `namespace`, `environment`, `stage`, `name`, `attributes`, `tags`, ...) are declared in `_context.tf`.

| Name | Type | Description |
|------|------|-------------|
| resource_group_name | `string` | Resource group that holds the store |
| location | `string` | Azure region |
| sku | `string` | `free` or `standard`; purge protection and soft delete need `standard` |
| local_auth_enabled | `bool` | Access-key authentication; `false` limits access to Microsoft Entra ID |
| public_network_access | `string` | `Enabled` or `Disabled` |
| purge_protection_enabled | `bool` | Purge protection (standard only) |
| soft_delete_retention_days | `number` | Retention for deleted stores (standard only) |
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
  source = "git::<repo-url>//modules/app-config?ref=app-config-v<version>"
}

dependency "resource_group" {
  config_path = "../resource-group"
}

dependency "app_service" {
  config_path = "../app-service"
}

inputs = {
  enabled     = true
  namespace   = "<namespace>"
  environment = "<environment>"
  stage       = "<stage>"
  name        = "<name>"

  local_auth_enabled         = false
  location                   = dependency.resource_group.outputs.location
  public_network_access      = "Enabled"
  purge_protection_enabled   = false
  resource_group_name        = dependency.resource_group.outputs.name
  sku                        = "standard"
  soft_delete_retention_days = 7

  role_assignments = {
    "app-data-reader" = {
      principal_id         = dependency.app_service.outputs.principal_id
      role_definition_name = "App Configuration Data Reader"
    }
  }
}
```

## License

Apache License 2.0. Copyright 2026 Raring Group LLC.
