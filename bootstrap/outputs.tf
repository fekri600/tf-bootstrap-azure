output "resource_group_name" {
  description = "RG where Terraform state is stored"
  value       = module.backend_setup.resource_group_name
}

output "storage_account_name" {
  description = "Storage Account used for state"
  value       = module.backend_setup.storage_account_name
}

output "container_name" {
  description = "Blob container used for state"
  value       = module.backend_setup.container_name
}

output "app_id" {
  value = module.oidc.app_id
}

output "service_principal_id" {
  value = module.oidc.service_principal_id
}
