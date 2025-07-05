variable "environment" { type = string }

variable "project_settings" {
  description = "Global project settings"
  type = object({
    project     = string # your project name
    location    = string # Azure region (e.g. eastus, westus2)
    name_prefix = string # short prefix for resource names
  })
}

variable "network" {
  description = "Network layout per environment"
  type = object({
    vpc_cidr                 = string       # address_space for azurerm_virtual_network
    public_subnets           = list(string) # address_prefixes for azurerm_subnet.public
    private_subnets          = list(string) # address_prefixes for azurerm_subnet.private
    availability_zones       = list(string) # zones = var.network[...].availability_zones for VMSS/Nat GW
    default_route_cidr_block = string       # used in NSG egress rules (0.0.0.0/0)
    resource_group_name      = string       # used in azurerm_virtual_network
  })
}
