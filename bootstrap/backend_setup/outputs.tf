output "resource_group_name" {
  description = "Name of the RG that holds Terraform state"
  value       = azurerm_resource_group.terraform_state_rg.name
}

output "resource_group_id" {
  description = "ID of the RG that holds Terraform state"
  value       = azurerm_resource_group.terraform_state_rg.id
}

output "storage_account_name" {
  description = "Name of the Storage Account for state"
  value       = azurerm_storage_account.terraform_state_sa.name
}

output "container_name" {
  description = "Name of the Blob container for state"
  value       = azurerm_storage_container.terraform_state_container.name
}
