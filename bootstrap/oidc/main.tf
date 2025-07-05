data "azurerm_subscription" "current" {}

# 1. Create an Azure AD App
resource "azuread_application" "github_app" {
  display_name = var.app_name
}

# 2. Service Principal for that App
resource "azuread_service_principal" "github_sp" {
  client_id = azuread_application.github_app.client_id

}

# 3. Federated Identity Credential for GitHub Actions
resource "azuread_application_federated_identity_credential" "github_fic" {
  application_id = azuread_application.github_app.id
  display_name   = "${var.app_name}-github-oidc"
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_repo}:ref:refs/heads/${var.github_branch}"
  audiences      = ["api://AzureADTokenExchange"]
}

# 4. Assign role (e.g. Contributor) on the RG so GH Actions can create resources
resource "azurerm_role_assignment" "github_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.github_sp.object_id
}
