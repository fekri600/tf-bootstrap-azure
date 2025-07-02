output "app_id" {
  description = "Client (Application) ID of the Azure AD Application for GitHub OIDC"
  value       = azuread_application.github_app.client_id
}

output "service_principal_id" {
  description = "Service Principal ID that GitHub Actions will use"
  value       = azuread_service_principal.github_sp.id
}
