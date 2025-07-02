module "backend_setup" {
  source               = "./backend_setup"
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_name = var.storage_account_name
  account_tier         = var.account_tier
  replication_type     = var.replication_type
  enable_versioning    = var.enable_versioning
  container_name       = var.container_name
}

module "oidc" {
  source        = "./oidc"
  app_name      = var.app_name
  github_repo   = var.github_repo
  github_branch = var.github_branch

  # <-- use the module output you just emitted:
  backend_rg_id = module.backend_setup.resource_group_id
}
