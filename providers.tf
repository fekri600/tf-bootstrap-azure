terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "i2507cloud"
    storage_account_name = "backendstate1290"
    container_name       = "tfstate"
    key                  = "terraform/state.tfstate"
  }
}

provider "azurerm" {
  subscription_id = ""
  tenant_id       = ""
  features  {}
}

provider "azuread" {
  tenant_id = ""
}
