variable "app_name" {
  description = "Name for the Azure AD application"
  type        = string
}

variable "github_repo" {
  description = "GitHub repo (owner/name) for OIDC subject"
  type        = string
}

variable "github_branch" {
  description = "Branch name to trust (e.g. main)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group for Terraform state backend"
  type        = string
}

variable "location" {
  description = "Azure region for the RG"
  type        = string
}
