resource "azurerm_resource_group" "terraform_state_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "terraform_state_sa" {
  name                       = var.storage_account_name
  resource_group_name        = azurerm_resource_group.terraform_state_rg.name
  location                   = azurerm_resource_group.terraform_state_rg.location
  account_tier               = var.account_tier
  account_replication_type   = var.replication_type
  https_traffic_only_enabled = true

  blob_properties {
    versioning_enabled = var.enable_versioning
  }
}

resource "azurerm_storage_container" "terraform_state_container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.terraform_state_sa.id
  container_access_type = "private"
}
