data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_api_management" "apim" {
  name                = var.apim_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

data "azurerm_application_insights" "app_insights" {
  name                = var.app_insights_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

data "azurerm_cdn_profile" "cdn_profile_website" {
  name                = var.cdn_profile_website_name
  resource_group_name = var.resource_group_name
}
