module "network" {
  source           = "./modules/network"
  environment      = terraform.workspace
  project_settings = var.project_settings
  network          = var.network[terraform.workspace]
  resource_group_name = trimspace(file("bootstrap/outputs/.backend_rg"))
  }
