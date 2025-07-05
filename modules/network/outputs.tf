# modules/network/outputs.tf

output "vnet_id" {
  description = "ID of the Azure virtual network"
  value       = azurerm_virtual_network.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = azurerm_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = azurerm_subnet.private[*].id
}
