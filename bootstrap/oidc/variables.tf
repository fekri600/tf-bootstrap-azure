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


