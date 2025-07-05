# outputs.tf
output "vnet_id" {
  value       = module.network.vnet_id
  description = "Virtual Network ID"
}

output "public_subnet_ids" {
  value       = module.network.public_subnet_ids
  description = "Public Subnet IDs"
}

output "private_subnet_ids" {
  value       = module.network.private_subnet_ids
  description = "Private Subnet IDs"
}