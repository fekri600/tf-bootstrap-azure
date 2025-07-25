#!/bin/bash
set -euo pipefail

# read the Azure bootstrap outputs
rg=$(<bootstrap/outputs/.backend_rg)
sa=$(<bootstrap/outputs/.backend_sa)
container=$(<bootstrap/outputs/.backend_container)
key=$(<bootstrap/outputs/.key)

# read the CLI‐captured IDs
subscription_id=$(<bootstrap/outputs/.subscription_id)
tenant_id=$(<bootstrap/outputs/.tenant_id)

cat > providers.tf <<EOF
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
    resource_group_name  = "$rg"
    storage_account_name = "$sa"
    container_name       = "$container"
    key                  = "$key"
  }
}

provider "azurerm" {
  subscription_id = "$subscription_id"
  tenant_id       = "$tenant_id"
  features  {}
}

provider "azuread" {
  tenant_id = "$tenant_id"
}
EOF

echo "✅ Generated providers.tf with AzureRM & AzureAD providers and backend config."
