locals {
  location_map = {
    uksouth = "uks"
    ukwest  = "ukw"
  }

  is_staging = var.environment_prefix == "staging"
  is_prod    = var.environment_prefix == "prod"
  is_not_dev = local.is_staging || local.is_prod

  # Revisit when log retention requirements are ready - https://tilneygroup.atlassian.net/browse/DH-2709!
  log_retention = {
    dev        = 30
    staging    = 30
    prod       = 90
    turned_off = 0
  }

  short_location = lookup(local.location_map, lower(replace(var.location, "/\\s/", "")))

  default_tags = {
    "CostCode"            = "934"
    "Department"          = "Financial Services"
    "Project"             = "Digital Hybrid"
    "Owner"               = "owner_placeholder"
    "terraform"           = "true"
    "environment"         = var.environment_prefix
    "main_directory_path" = "./terraform/apim"
  }

  subnet_cidr = {
    private_link_subnet_cidr  = cidrsubnet(var.vnet_cidr, 5, 2)
    apim_external_subnet_cidr = cidrsubnet(var.vnet_cidr, 5, 1)
    fa_subnet_cidr            = cidrsubnet(var.vnet_cidr, 2, 3)
  }
}