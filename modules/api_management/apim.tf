resource "azurerm_api_management" "api" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  location             = var.location
  publisher_name       = var.publisher_name
  publisher_email      = var.publisher_email
  sku_name             = var.api_management_sku_name
  virtual_network_type = "External"
  tags                 = merge(map("tf_module_path", "./terraform/modules/api_management"), var.tags)

  virtual_network_configuration {
    subnet_id = var.external_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  count                          = var.log_analytics_workspace_id != null ? 1 : 0
  name                           = "${azurerm_api_management.api.name}-diag-settings"
  target_resource_id             = azurerm_api_management.api.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "AzureDiagnostics"

  log {
    category = "GatewayLogs"
    enabled  = true
    retention_policy {
      enabled = true
      days    = var.retention_days
    }
  }

  log {
    category = "WebSocketConnectionLogs"
    enabled  = true
    retention_policy {
      enabled = true
      days    = var.retention_days
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = var.retention_days
    }
  }
}

resource "azurerm_api_management_backend" "backend" {
  for_each            = var.api_backends
  name                = each.value.name
  url                 = each.value.url
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.api.name
  protocol            = "http"
  tls {
    validate_certificate_name  = true
    validate_certificate_chain = each.value.validate_certificate_chain
  }
}
