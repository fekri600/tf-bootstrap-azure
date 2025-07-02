#!/bin/bash
set -euo pipefail

# read the CLI‐captured IDs
subscription_id=$(<bootstrap/outputs/.subscription_id)
tenant_id=$(<bootstrap/outputs/.tenant_id)

cat > bootstrap/providers.tf <<EOF
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
  subscription_id = "$subscription_id"
  tenant_id       = "$tenant_id"
  features {}
}

provider "azuread" {
  tenant_id       = "$tenant_id"
}
EOF

echo "✅ Generated Backend providers.tf"
