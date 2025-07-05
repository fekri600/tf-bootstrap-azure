locals {
  project     = var.project_settings.project
  region      = var.project_settings.location
  name_prefix = var.project_settings.name_prefix
  #paths
  scripts  = "${path.root}/scripts"
}
