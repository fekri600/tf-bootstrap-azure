variable "resource_group_name" {
  description = "RG for hosting Terraform state"
  type        = string
}

variable "location" {
  description = "Azure region for the RG"
  type        = string
}

variable "storage_account_name" {
  description = "Unique Storage Account name (3–24 lowercase letters/numbers)"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "enable_versioning" {
  description = "Enable blob versioning"
  type        = bool
  default     = true
}

variable "container_name" {
  description = "Blob container for TF state"
  type        = string
  default     = "tfstate"
}
