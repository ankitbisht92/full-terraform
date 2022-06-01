module "function_app_projections" {
  source                           = "../modules/function_app_node"
  resource_group_name              = data.azurerm_resource_group.resource_group.name
  location                         = data.azurerm_resource_group.resource_group.location
  app_service_plan_id              = local.app_service_plan_id
  name                             = "fun-${local.short_location}-${var.environment_prefix}-${var.app_name}-projections"
  storage_account_name             = "st${local.short_location}tsw${replace(var.environment_prefix, "-", "")}prjs"
  app_code_path                    = var.projections_function_app_code_path
  os_type                          = "linux"
  node_version                     = "12"
  app_insights_instrumentation_key = data.azurerm_application_insights.app_insights.instrumentation_key
  log_analytics_workspace_id       = var.centralised_log_analytics_workspace_id
  retention_days                   = lookup(local.log_retention, var.environment_prefix, lookup(local.log_retention, local.is_dev ? "dev" : "prod"))
  subnet_id                        = var.fa_subnet_id
  apim_subnet_id                   = data.azurerm_subnet.apim_subnet.id
  elastic_instance_minimum         = var.elastic_instance_minimum
  requires_vnet_integration        = local.requires_vnet_integration 
  tags                             = local.default_tags
}

module "function_app_returns" {
  source                           = "../modules/function_app_node"
  resource_group_name              = data.azurerm_resource_group.resource_group.name
  location                         = data.azurerm_resource_group.resource_group.location
  app_service_plan_id              = local.app_service_plan_id
  name                             = "fun-${local.short_location}-${var.environment_prefix}-${var.app_name}-returns"
  storage_account_name             = "st${local.short_location}tsw${replace(var.environment_prefix, "-", "")}rtns"
  app_code_path                    = var.returns_function_app_code_path
  os_type                          = "linux"
  node_version                     = "12"
  app_insights_instrumentation_key = data.azurerm_application_insights.app_insights.instrumentation_key
  log_analytics_workspace_id       = var.centralised_log_analytics_workspace_id
  retention_days                   = lookup(local.log_retention, var.environment_prefix, lookup(local.log_retention, local.is_dev ? "dev" : "prod"))
  subnet_id                        = var.fa_subnet_id
  apim_subnet_id                   = data.azurerm_subnet.apim_subnet.id
  elastic_instance_minimum         = var.elastic_instance_minimum
  requires_vnet_integration        = local.requires_vnet_integration 
  tags                             = local.default_tags
}

module "function_app_wrappers" {
  source                           = "../modules/function_app_node"
  resource_group_name              = data.azurerm_resource_group.resource_group.name
  location                         = data.azurerm_resource_group.resource_group.location
  app_service_plan_id              = local.app_service_plan_id
  name                             = "fun-${local.short_location}-${var.environment_prefix}-${var.app_name}-wrappers"
  storage_account_name             = "st${local.short_location}tsw${replace(var.environment_prefix, "-", "")}wps"
  app_code_path                    = var.wrappers_function_app_code_path
  os_type                          = "linux"
  node_version                     = "12"
  app_insights_instrumentation_key = data.azurerm_application_insights.app_insights.instrumentation_key
  app_settings = {
    APIM_BASE_URL             = local.apim_base_url
    MYACCOUNTS_AES_KEY        = var.myaccounts_aes_key
    MYACCOUNTS_AES_KEY_VECTOR = var.myaccounts_aes_key_vector
  }
  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id
  retention_days             = lookup(local.log_retention, var.environment_prefix, lookup(local.log_retention, local.is_dev ? "dev" : "prod"))
  subnet_id                  = var.fa_subnet_id
  apim_subnet_id             = data.azurerm_subnet.apim_subnet.id
  elastic_instance_minimum   = var.elastic_instance_minimum
  requires_vnet_integration  = local.requires_vnet_integration 
  tags                       = local.default_tags
}