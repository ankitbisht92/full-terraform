module "api_functions_asp" {
  count                      = local.is_dev ? 1 : 0
  source                     = "../modules/app_service_plan"
  name                       = "asp-${local.short_location}-${var.environment_prefix}-${var.app_name}"
  resource_group_name        = data.azurerm_resource_group.resource_group.name
  location                   = data.azurerm_resource_group.resource_group.location
  kind                       = "FunctionApp"
  tier                       = "Dynamic"
  size                       = "Y1"
  reserved                   = true
  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id
  retention_days             = lookup(local.log_retention, var.environment_prefix, lookup(local.log_retention, local.is_dev ? "dev" : "prod"))
  tags                       = local.default_tags
}
