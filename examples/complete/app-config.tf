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
##  modules/app-config/examples/complete/app-config.tf
##
##  Creates a resource group and an App Configuration store. Purge protection
##  is off so the example can be destroyed and re-created.
## ----------------------------------------------------------------------------

## Resource Group
module "resource_group" {
  source  = "../../../resource-group"
  context = module.context.self

  location = var.region
}


## App Configuration
module "app_config" {
  source  = "../../"
  context = module.context.self

  local_auth_enabled         = false
  location                   = module.resource_group.location
  public_network_access      = "Enabled"
  purge_protection_enabled   = false
  resource_group_name        = module.resource_group.name
  sku                        = "standard"
  soft_delete_retention_days = 7

  role_assignments = {}
}
