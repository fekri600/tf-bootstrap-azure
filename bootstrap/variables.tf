# ────────────── Backend Setup ──────────────

variable "resource_group_name" {
  description = "Name of the Azure Resource Group for Terraform state backend"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "storage_account_name" {
  description = "Globally-unique Storage Account name (3–24 lowercase letters/numbers)"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "enable_versioning" {
  description = "Enable blob versioning on the storage account"
  type        = bool
  default     = true
}

variable "container_name" {
  description = "Blob container name for Terraform state"
  type        = string
  default     = "tfstate"
}

# ────────────── OIDC / GitHub Actions ──────────────

variable "app_name" {
  description = "Name of the Azure AD Application for GitHub OIDC"
  type        = string
}

variable "github_repo" {
  description = "GitHub repo to trust (format: owner/name)"
  type        = string
}

variable "github_branch" {
  description = "Branch name to trust for OIDC tokens (e.g. main)"
  type        = string
}

