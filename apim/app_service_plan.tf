module "api_functions_asp" {
  count                      = local.is_not_dev ? 1 : 0
  source                     = "../modules/app_service_plan"
  name                       = "asp-${local.short_location}-${var.environment_prefix}-${var.app_name}"
  resource_group_name        = data.azurerm_resource_group.resource_group.name
  location                   = data.azurerm_resource_group.resource_group.location
  kind                       = "elastic"
  tier                       = "ElasticPremium"
  size                       = "EP1"
  capacity                   = var.asp_capacity
  zone_redundant             = var.is_zone_redundant
  per_site_scaling           = true
  reserved                   = true
  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id
  retention_days             = lookup(local.log_retention, var.environment_prefix)
  tags                       = local.default_tags
}
