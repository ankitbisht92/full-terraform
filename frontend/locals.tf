locals {
  location_map = {
    uksouth = "uks"
    ukwest  = "ukw"
  }

  short_location = lookup(local.location_map, lower(replace(var.location, "/\\s/", "")))

  is_staging = var.environment_prefix == "staging"
  is_prod    = length(regexall("prod", var.environment_prefix)) > 0
  is_not_dev = local.is_staging || local.is_prod
  is_dev     = !local.is_not_dev

  storybook_cdn_profile = var.is_pr_num_odd ? var.cdn_profile_storybook_name : var.cdn_profile_storybook_name_1
  website_cdn_profile   = var.is_pr_num_odd ? var.cdn_profile_website_name : var.cdn_profile_website_name_1

  default_tags = {
    "CostCode"            = "934"
    "Department"          = "Financial Services"
    "Project"             = "Digital Hybrid"
    "Owner"               = "owner_placeholder"
    "terraform"           = "true"
    "main_directory_path" = "./terraform/infra"
    "env_prefix"          = var.environment_prefix
    "BranchName"          = local.is_not_dev ? "master" : var.git_branch_name
  }

  # Revisit when log retention requirements are ready - https://tilneygroup.atlassian.net/browse/DH-2709!
  log_retention = {
    dev     = 30
    staging = 30
    prod    = 90
  }
}
