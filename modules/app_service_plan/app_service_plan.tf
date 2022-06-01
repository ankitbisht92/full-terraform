resource "azurerm_app_service_plan" "asp" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = var.kind
  reserved            = var.reserved
  tags                = merge(map("tf_module_path", "./terraform/modules/app_service_plan"), var.tags)
  zone_redundant      = var.zone_redundant
  per_site_scaling    = var.per_site_scaling
  sku {
    tier     = var.tier
    size     = var.size
    capacity = var.capacity
  }
}


resource "azurerm_monitor_diagnostic_setting" "central_diagnostic_setting" {
  name                       = "${var.name}-diag-settings"
  target_resource_id         = azurerm_app_service_plan.asp.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = var.retention_days
    }
  }
}