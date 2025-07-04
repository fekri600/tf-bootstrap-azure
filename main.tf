module "network" {
  source           = "./modules/network"
  environment      = terraform.workspace
  project_settings = var.project_settings
  network          = var.network[terraform.workspace]
}
