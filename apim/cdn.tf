resource "azurerm_cdn_profile" "website" {
  name                = "cdn-gbl-${var.environment_prefix}-${var.app_name}-web"
  location            = "Global"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  sku                 = "Standard_Microsoft"
  tags                = merge(var.tags, local.default_tags)
}

resource "azurerm_monitor_diagnostic_setting" "website" {
  name                       = "${azurerm_cdn_profile.website.name}-diag-settings"
  target_resource_id         = azurerm_cdn_profile.website.id
  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id

  log {
    category = "AzureCdnAccessLog"
    enabled  = true
    retention_policy {
      enabled = true
      days    = lookup(local.log_retention, var.environment_prefix)
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = lookup(local.log_retention, var.environment_prefix)
    }
  }
}

resource "azurerm_cdn_profile" "storybook" {
  name                = "cdn-gbl-${var.environment_prefix}-${var.app_name}-sb"
  location            = "Global"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  sku                 = "Standard_Microsoft"
  tags                = merge(var.tags, local.default_tags)
}

resource "azurerm_monitor_diagnostic_setting" "storybook" {
  name                       = "${azurerm_cdn_profile.storybook.name}-diag-settings"
  target_resource_id         = azurerm_cdn_profile.storybook.id
  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id

  log {
    category = "AzureCdnAccessLog"
    enabled  = true
    retention_policy {
      enabled = true
      days    = lookup(local.log_retention, var.environment_prefix)
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = lookup(local.log_retention, var.environment_prefix)
    }
  }
}

resource "azurerm_cdn_profile" "website_1" {
  count               = var.environment_prefix == "dev" ? 1 : 0
  name                = "cdn-gbl-${var.environment_prefix}-${var.app_name}-web-1"
  location            = "Global"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  sku                 = "Standard_Microsoft"
  tags                = merge(var.tags, local.default_tags)
}

resource "azurerm_monitor_diagnostic_setting" "website_1" {
  count                      = var.environment_prefix == "dev" ? 1 : 0
  name                       = "${azurerm_cdn_profile.website_1[0].name}-diag-settings"
  target_resource_id         = azurerm_cdn_profile.website_1[0].id
  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id

  log {
    category = "AzureCdnAccessLog"
    enabled  = true
    retention_policy {
      enabled = true
      days    = lookup(local.log_retention, var.environment_prefix)
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = lookup(local.log_retention, var.environment_prefix)
    }
  }
}

resource "azurerm_cdn_profile" "storybook_1" {
  count               = var.environment_prefix == "dev" ? 1 : 0
  name                = "cdn-gbl-${var.environment_prefix}-${var.app_name}-sb-1"
  location            = "Global"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  sku                 = "Standard_Microsoft"
  tags                = merge(var.tags, local.default_tags)
}

resource "azurerm_monitor_diagnostic_setting" "storybook_1" {
  count                      = var.environment_prefix == "dev" ? 1 : 0
  name                       = "${azurerm_cdn_profile.storybook_1[0].name}-diag-settings"
  target_resource_id         = azurerm_cdn_profile.storybook_1[0].id
  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id

  log {
    category = "AzureCdnAccessLog"
    enabled  = true
    retention_policy {
      enabled = true
      days    = lookup(local.log_retention, var.environment_prefix)
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = lookup(local.log_retention, var.environment_prefix)
    }
  }
}