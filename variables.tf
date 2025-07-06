variable "project_settings" {
  description = "Project configuration settings"
  type = object({
    project     = string
    location    = string
    name_prefix = string
  })
}

variable "network" {
  description = "Network layout per environment"
  type = map(object({
    vnet_cidr                 = string       # address_space for azurerm_virtual_network
    public_subnets           = list(string) # address_prefixes for azurerm_subnet.public
    private_subnets          = list(string) # address_prefixes for azurerm_subnet.private
    availability_zones       = list(string) # zones = var.network[...].availability_zones for VMSS/Nat GW
    default_route_cidr_block = string       # used in NSG egress rules (0.0.0.0/0)
  }))
}


