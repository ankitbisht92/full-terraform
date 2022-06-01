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

  api_name                   = "${var.environment_prefix}-${var.app_name}"
  api_version                = !local.is_prod ? var.environment_prefix : split("-", var.environment_prefix)[1]
  api_path                   = local.is_dev ? "dev" : split("-", var.environment_prefix)[0]

  operation_endpoints        = { for api in module.api_operation : upper(replace(api.operation_id, "-", "_")) => api.url_template }
  xplan_operation_endpoints  = { for api in module.api_operation_xplan : upper(replace(api.operation_id, "-", "_")) => api.url_template }
  api_endpoints              = merge(local.operation_endpoints, local.xplan_operation_endpoints)
  //website_hostname_secondary = local.is_not_dev ? "https://${var.cname_record_secondary}.${var.public_dns_zone_name_secondary}" : null
  website_hostname_primary   = local.is_not_dev ? "https://${var.cname_record}.${var.public_dns_zone_name}" : null
  //cors_allowed_origins       = local.is_not_dev ? concat(var.cors_allowed_origins, [var.website_hostname], [local.website_hostname_secondary]) : concat(var.cors_allowed_origins, [var.website_hostname])
  //cors_allowed_origins_xplan = local.is_not_dev ? concat(var.cors_allowed_origins_xplan, [var.website_hostname], [local.website_hostname_secondary]) : concat(var.cors_allowed_origins, [var.website_hostname])
  cors_allowed_origins       = local.is_staging ? concat(var.cors_allowed_origins, [var.website_hostname]) : local.is_prod ? concat(var.cors_allowed_origins, [local.website_hostname_primary], [var.website_hostname]) : concat(var.cors_allowed_origins, [var.website_hostname])
  cors_allowed_origins_xplan = local.is_staging ? concat(var.cors_allowed_origins_xplan, [var.website_hostname]) : local.is_prod ? concat(var.cors_allowed_origins, [local.website_hostname_primary], [var.website_hostname]) : concat(var.cors_allowed_origins, [var.website_hostname])

  api_definitions = {
    for k, v in
    tomap(jsondecode(file("${path.module}/api_definitions.json")))["api_definitions"] :
    v["operation_id"] => v
  }

  xplan_api_definitions = {
    for k, v in
    tomap(jsondecode(file("${path.module}/xplan_api_definitions.json")))["api_definitions"] :
    v["operation_id"] => v
  }

  myaccount_endpoints_requiring_guest_auth = {
    for k, v in
    tomap(jsondecode(file("${path.module}/myaccounts_apis_with_guest_login.json")))["api_definitions"] :
    v["operation_id"] => v
  }

  apim_base_url = "${data.azurerm_api_management.apim.gateway_url}/${module.apim_api.path}/${local.api_version}"

  api_backends = {
    projections_function_app = "https://${module.function_app_projections.url}/api/"
    returns_function_app     = "https://${module.function_app_returns.url}/api/"
    wrappers_function_app    = "https://${module.function_app_wrappers.url}/api/"
  }

  default_tags = {
    "CostCode"            = "934"
    "Department"          = "Financial Services"
    "Project"             = "Digital Hybrid"
    "Owner"               = "owner_placeholder"
    "terraform"           = "true"
    "main_directory_path" = "./terraform/backend"
    "env_prefix"          = var.environment_prefix
    "BranchName"          = local.is_not_dev ? "master" : var.git_branch_name
  }

  # Revisit when log retention requirements are ready - https://tilneygroup.atlassian.net/browse/DH-2709!
  log_retention = {
    dev     = 30
    staging = 30
    prod    = 90
  }

  app_service_plan_id       = local.is_dev ? module.api_functions_asp[0].id : var.app_service_plan_id
  requires_vnet_integration = local.is_dev ? false : true 
}
