module "apim_api" {
  source                           = "../modules/api_management_api"
  name                             = local.api_name
  resource_group_name              = data.azurerm_resource_group.resource_group.name
  api_management_name              = data.azurerm_api_management.apim.name
  display_name                     = "${var.environment_prefix}-${var.app_name}"
  path                             = local.api_path
  protocols                        = ["https"]
  subscription_required            = false
  description                      = "${var.app_name} API."
  api_management_logger_name       = "apim-${local.short_location}-${var.environment_prefix}-logger"
  app_insights_id                  = data.azurerm_application_insights.app_insights.id
  app_insights_instrumentation_key = data.azurerm_application_insights.app_insights.instrumentation_key
  api_version_set_id               = var.version_set_id
  api_version                      = local.api_version
}

module "api_operation" {
  source              = "../modules/api_operation"
  for_each            = local.api_definitions
  apim_api_name       = module.apim_api.name
  apim_name           = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  operation_id        = lookup(each.value, "operation_id", null)
  display_name        = lookup(each.value, "display_name", null)
  method              = lookup(each.value.policy.cors, "method", null)
  url_template        = lookup(each.value, "url_template", null)
  description         = lookup(each.value, "description", null)
  path_params         = lookup(each.value, "path_params", [])
  is_mock             = false
}

module "api_management_policy" {
  source              = "../modules/api_management_policy"
  for_each            = local.api_definitions
  apim_api_name       = module.apim_api.name
  apim_name           = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  operation_id        = lookup(each.value, "operation_id", null)
  xml_policy_file = templatefile("../modules/policy_documents/api_operation_policy.xml", {
    config = {
      backend_url          = lookup(local.api_backends, lookup(each.value.policy, "backend_url", ""), null),
      backend_id           = lookup(each.value.policy, "backend_id", null),
      enable_cors          = length(local.cors_allowed_origins) > 0,
      cors_allowed_method  = lookup(each.value.policy.cors, "method", null),
      cors_allowed_headers = lookup(each.value.policy.cors, "headers", []),
      cors_exposed_headers = lookup(each.value.policy.cors, "expose_headers", null),
      cors_allowed_origins = local.cors_allowed_origins,
      allow-credentials    = lookup(each.value.policy.cors, "allow-credentials", false),
      headers              = lookup(each.value.policy, "set_header", []),
      outbound_headers     = lookup(each.value.policy, "outbound_headers", []),
      rewrite_url          = lookup(each.value.policy, "rewrite_url", null),
      variables            = lookup(each.value.policy, "set_variable", null),
      authentication-basic = lookup(each.value.policy, "authentication-basic", null)
    }
  })
  depends_on = [module.api_operation]
}

module "api_operation_xplan" {
  source              = "../modules/api_operation"
  for_each            = local.xplan_api_definitions
  apim_api_name       = module.apim_api.name
  apim_name           = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  operation_id        = lookup(each.value, "operation_id", null)
  display_name        = lookup(each.value, "display_name", null)
  method              = lookup(each.value.policy.cors, "method", null)
  url_template        = lookup(each.value, "url_template", null)
  description         = lookup(each.value, "description", null)
  path_params         = lookup(each.value, "path_params", [])
  is_mock             = false
}

module "api_management_policy_xplan" {
  source              = "../modules/api_management_policy"
  for_each            = local.xplan_api_definitions
  apim_api_name       = module.apim_api.name
  apim_name           = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  operation_id        = lookup(each.value, "operation_id", null)
  xml_policy_file = templatefile("../modules/policy_documents/api_operation_policy_xplan.xml", {
    config = {
      backend_url          = lookup(local.api_backends, lookup(each.value.policy, "backend_url", ""), null),
      backend_id           = lookup(each.value.policy, "backend_id", null),
      cors_allowed_method  = lookup(each.value.policy.cors, "method", null),
      cors_allowed_headers = lookup(each.value.policy.cors, "headers", []),
      cors_exposed_headers = lookup(each.value.policy.cors, "expose_headers", null),
      cors_allowed_origins = local.cors_allowed_origins_xplan,
      allow-credentials    = lookup(each.value.policy.cors, "allow-credentials", false),
      headers              = lookup(each.value.policy, "set_header", null),
      outbound_headers     = lookup(each.value.policy, "outbound_headers", null),
      rewrite_url          = lookup(each.value.policy, "rewrite_url", null),
      variables            = lookup(each.value.policy, "set_variable", null),
      authentication-basic = lookup(each.value.policy, "authentication-basic", null),
      validate_request     = lookup(each.value.policy, "validate_request", null),
      validate_request_url = replace(lookup(lookup(each.value.policy, "validate_request", {}), "url", ""), "{{function-app-baseurl}}", local.api_backends.projections_function_app),
      body                 = lookup(each.value.policy, "body", null)
    }
  })
  depends_on = [module.api_operation]
}

module "myaccounts_apis_requiring_guest_login" {
  source              = "../modules/api_operation"
  for_each            = local.myaccount_endpoints_requiring_guest_auth
  apim_api_name       = module.apim_api.name
  apim_name           = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  operation_id        = lookup(each.value, "operation_id", null)
  display_name        = lookup(each.value, "display_name", null)
  method              = lookup(each.value.policy.cors, "method", null)
  url_template        = lookup(each.value, "url_template", null)
  description         = lookup(each.value, "description", null)
  path_params         = lookup(each.value, "path_params", [])
  is_mock             = false
}


module "myaccounts_apis_requiring_guest_login_policy" {
  source              = "../modules/api_management_policy"
  for_each            = local.myaccount_endpoints_requiring_guest_auth
  apim_api_name       = module.apim_api.name
  apim_name           = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  operation_id        = lookup(each.value, "operation_id", null)
  xml_policy_file = templatefile("../modules/policy_documents/myaccount_guest_auth_flow.xml", {
    config = {
      backend_url          = lookup(local.api_backends, lookup(each.value.policy, "backend_url", ""), null),
      backend_id           = lookup(each.value.policy, "backend_id", null),
      rewrite_uri          = lookup(each.value.policy, "rewrite_url", lookup(each.value, "url_template", null)),
      auth_url             = "${local.apim_base_url}/Auth/token",
      cors_allowed_method  = lookup(each.value.policy.cors, "method", null),
      cors_allowed_headers = lookup(each.value.policy.cors, "headers", []),
      cors_exposed_headers = lookup(each.value.policy.cors, "expose_headers", null),
      allow-credentials    = lookup(each.value.policy.cors, "allow-credentials", false),
      cors_allowed_origins = local.cors_allowed_origins
    }
  })
  depends_on = [module.myaccounts_apis_requiring_guest_login]
}

module "mocked_response_api_operation" {
  source              = "../modules/api_operation"
  apim_api_name       = module.apim_api.name
  apim_name           = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  operation_id        = "get-endpoints"
  display_name        = "get-endpoints"
  method              = "GET"
  url_template        = "/endpoints"
  description         = "Returns a JSON object with all the API endpoints."
  path_params         = []
  is_mock             = true
  mock_sample         = jsonencode(local.api_endpoints)
  depends_on          = [module.api_operation]
}

module "mocked_response_api_operation_policy" {
  source              = "../modules/api_management_policy"
  apim_api_name       = module.apim_api.name
  apim_name           = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  operation_id        = module.mocked_response_api_operation.operation_id
  xml_policy_file     = file("../modules/policy_documents/api_operation_mocked_response_policy.xml")
  depends_on          = [module.mocked_response_api_operation]
}

module "devadmin_api_operation" {
  count               = local.is_prod ? 0 : 1
  source              = "../modules/api_operation"
  apim_api_name       = module.apim_api.name
  apim_name           = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  operation_id        = "devadmin"
  display_name        = "DevAdmin"
  method              = "POST"
  url_template        = "/devadmin"
  description         = "Endpoint for data manipulation in dev/test environments"
}

module "devadmin_api_operation_policy" {
  count               = local.is_prod ? 0 : 1
  source              = "../modules/api_management_policy"
  apim_api_name       = module.apim_api.name
  apim_name           = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  operation_id        = module.devadmin_api_operation[0].operation_id
  xml_policy_file = templatefile("../modules/policy_documents/api_operation_policy.xml", {
    config = {
      backend_url          = null,
      backend_id           = "bestinvest-myaccounts-api",
      enable_cors          = false,
      cors_allowed_method  = null,
      cors_allowed_headers = [],
      cors_exposed_headers = null,
      cors_allowed_origins = [],
      allow-credentials    = false,
      headers              = [],
      outbound_headers     = [],
      rewrite_url          = null,
      variables            = null,
      authentication-basic = null
    }
  })
}
