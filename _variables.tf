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
##  modules/app-config/_variables.tf
##
##  Input variables for the App Configuration module.
## ----------------------------------------------------------------------------

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group that holds the App Configuration store"
}

variable "location" {
  type        = string
  description = "Azure region where the App Configuration store is created"
}

variable "sku" {
  type        = string
  description = "App Configuration SKU: free, developer, standard or premium; purge protection and soft delete work only on standard"
}

variable "local_auth_enabled" {
  type        = bool
  description = "Whether access-key authentication is enabled; false limits access to Microsoft Entra ID"
}

variable "public_network_access" {
  type        = string
  description = "Public network access of the store: Enabled or Disabled. null leaves it Automatic, which cannot be restored once a value is set"
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Whether purge protection is enabled (standard SKU only)"
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Days a deleted store is retained before purge, 1 to 7 (standard SKU only; changing it forces a new store)"
}

variable "role_assignments" {
  type = map(object({
    principal_id         = string
    role_definition_name = string
  }))
  description = "Azure RBAC role assignments on the store, keyed by a stable name (e.g. App Configuration Data Reader for an app identity)"
}
