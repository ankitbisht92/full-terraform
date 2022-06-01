locals {
  front_door_name      = "fd-gbl-${var.environment_prefix}-dh"
  custom_frontend_name = "preview"
  default_tags = {
    "CostCode"            = "934"
    "Department"          = "Financial Services"
    "Project"             = "Digital Hybrid"
    "Owner"               = "owner_placeholder"
    "terraform"           = "true"
    "environment"         = var.environment_prefix
    "main_directory_path" = "./terraform/front_door"
  }

  # Revisit when log retention requirements are ready - https://tilneygroup.atlassian.net/browse/DH-2709!
  log_retention = {
    staging = 30
    prod    = 90
  }

  apim_hostname = split("//", data.azurerm_api_management.apim.gateway_url)[1]

}
