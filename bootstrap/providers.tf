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
}

provider "azurerm" {
  subscription_id = "24772daf-6ca5-4369-9a70-95b863ad85c6"
  tenant_id       = "aa959dfb-84df-4d8d-8765-6d22e83d7744"
  features {}
}

provider "azuread" {
  tenant_id       = "aa959dfb-84df-4d8d-8765-6d22e83d7744"
}
