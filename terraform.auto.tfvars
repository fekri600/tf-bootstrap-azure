# ======================
# Project Configuration
# ======================
project_settings = {
  project     = "i2507cloud"
  location    = "eastus" # maps from us-east-1 to Azure’s eastus
  name_prefix = "fs"
}


# ======================
# Network Configuration
# ======================
network = {
  staging = {
    vpc_cidr                 = "10.0.0.0/16"
    public_subnets           = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets          = ["10.0.11.0/24", "10.0.12.0/24"]
    availability_zones       = ["1", "2"] # Azure zone IDs in your region
    default_route_cidr_block = "0.0.0.0/0"
    resource_group_name      = "network"
  }

  production = {
    vpc_cidr                 = "10.1.0.0/16"
    public_subnets           = ["10.1.1.0/24", "10.1.2.0/24"]
    private_subnets          = ["10.1.11.0/24", "10.1.12.0/24"]
    availability_zones       = ["1", "2"]
    default_route_cidr_block = "0.0.0.0/0"
    resource_group_name      = "network"
  }
}

