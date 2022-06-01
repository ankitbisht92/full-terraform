// The actual function app
resource "azurerm_function_app" "this" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = azurerm_storage_account.this.name
  storage_account_access_key = azurerm_storage_account.this.primary_access_key

  version    = "~3"
  https_only = true
  os_type    = var.os_type

  app_settings = merge(var.app_settings,
    {
      WEBSITE_RUN_FROM_PACKAGE       = "https://${azurerm_storage_account.this.name}.blob.core.windows.net/${azurerm_storage_container.this.name}/${azurerm_storage_blob.this.name}${data.azurerm_storage_account_sas.this.sas}"
      FUNCTIONS_WORKER_RUNTIME       = "node"
      FUNCTION_APP_EDIT_MODE         = "readonly"
      HASH                           = base64encode(filesha256(var.app_code_path))
      APPINSIGHTS_INSTRUMENTATIONKEY = var.app_insights_instrumentation_key
  })

  auth_settings {
    enabled = false
  }

  site_config {
    linux_fx_version         = "NODE|${var.node_version}"
    http2_enabled            = true
    ftps_state               = "FtpsOnly"
    elastic_instance_minimum = var.elastic_instance_minimum
    // Allow inbound traffic from the APIM VNet
    ip_restriction {
      name                      = "Allow traffic from apim subnet"
      virtual_network_subnet_id = var.apim_subnet_id
      action                    = "Allow"
      priority                  = 1
    }
    // Implicit deny all is created for us

    // Deny all access to the Function app deployment endpoint
    scm_ip_restriction {
      name       = "Deny all access"
      ip_address = "0.0.0.0/0"
      action     = "Deny"
      priority   = 1
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.name}-diag-settings"
  target_resource_id         = azurerm_function_app.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "FunctionAppLogs"
    enabled  = true
    retention_policy {
      days    = var.retention_days
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      days    = var.retention_days
      enabled = true
    }
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  count          = local.is_premium ? 1 : 0
  app_service_id = azurerm_function_app.this.id
  subnet_id      = var.subnet_id
}