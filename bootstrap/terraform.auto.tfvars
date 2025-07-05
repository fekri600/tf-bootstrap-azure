# ────────────── Azure Backend Setup ──────────────

# The RG that will hold your state storage
resource_group_name = "rg-terraform-backend-1290"

# Azure region (closest to your AWS us-east-1)
location = "eastus"

# Must be globally unique, 3–24 lowercase letters/numbers
storage_account_name = "backendstate1290"

# (You can omit these if you’re happy with defaults)
# account_tier      = "Standard"
# replication_type  = "LRS"
# enable_versioning = true
# container_name    = "tfstate"


# ────────────── Azure OIDC / GitHub Actions ──────────────

# Name for the Azure AD Application
app_name = "TRUST_ROLE_GITHUB"

# GitHub repo and branch to trust for OIDC tokens
github_repo   = "fekri600/tf-bootstrap-azure"
github_branch = "main"


