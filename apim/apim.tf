module "apim" {
  source                     = "../modules/api_management"
  name                       = "apim-${local.short_location}-${var.environment_prefix}-${var.app_name}"
  resource_group_name        = data.azurerm_resource_group.resource_group.name
  location                   = data.azurerm_resource_group.resource_group.location
  api_management_sku_name    = var.api_management_sku_name
  external_subnet_id         = azurerm_subnet.apim_external_subnet.id
  tags                       = merge(local.default_tags, var.tags)
  api_backends               = var.api_backends
  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id
  retention_days             = lookup(local.log_retention, var.environment_prefix)
}
