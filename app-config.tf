## ----------------------------------------------------------------------------
## Copyright 2026 Raring Group LLC
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
## ----------------------------------------------------------------------------
##
##  modules/app-config/app-config.tf
##
##  Azure App Configuration store with optional RBAC role assignments.
## ----------------------------------------------------------------------------

## App Configuration Context
module "app_config_context" {
  source  = "git::https://github.com/raringgroup/terraform-null-context.git?ref=v0.1.0"
  context = module.context.self

  attributes      = ["appcfg"]
  id_length_limit = 50
}


## App Configuration Store
resource "azurerm_app_configuration" "this" {
  count = module.app_config_context.enabled ? 1 : 0

  local_auth_enabled         = var.local_auth_enabled
  location                   = var.location
  name                       = module.app_config_context.id
  public_network_access      = var.public_network_access
  purge_protection_enabled   = var.purge_protection_enabled
  resource_group_name        = var.resource_group_name
  sku                        = var.sku
  soft_delete_retention_days = var.soft_delete_retention_days
  tags                       = module.app_config_context.tags
}


## Role Assignments
resource "azurerm_role_assignment" "this" {
  for_each = module.app_config_context.enabled ? var.role_assignments : {}

  principal_id         = each.value.principal_id
  role_definition_name = each.value.role_definition_name
  scope                = azurerm_app_configuration.this[0].id
}
