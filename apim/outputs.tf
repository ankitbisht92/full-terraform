output "apim_name" {
  value       = module.apim.name
  description = "Mame of the APIM created"
}

output "apim_vnet_name" {
  value       = azurerm_virtual_network.this.name
  description = "Name of the VNet which houses APIM"
}

output "fa_subnet_id" {
  value       = local.is_not_dev ? azurerm_subnet.fa_subnet[0].id : null
  description = "ID of function app subnet"
}

output "apim_subnet_name" {
  value       = azurerm_subnet.apim_external_subnet.name
  description = "Name of the subnet which houses APIM"
}

output "cdn_profile_website_name" {
  value       = azurerm_cdn_profile.website.name
  description = "Name of the CDN profile for the frontend website created for this environment"
}

output "cdn_profile_storybook_name" {
  value       = azurerm_cdn_profile.storybook.name
  description = "Name of the CDN profile for storybook created for this environment"
}

output "cdn_profile_website_name_1" {
  value       = var.environment_prefix == "dev" ? azurerm_cdn_profile.website_1[0].name : null
  description = "Name of the second CDN profile for the frontend website created for the development environment"
}

output "cdn_profile_storybook_name_1" {
  value       = var.environment_prefix == "dev" ? azurerm_cdn_profile.storybook_1[0].name : null
  description = "Name of the second CDN profile for storybook created for the development environment"
}

output "app_insights_name" {
  value       = azurerm_application_insights.app_insights.name
  description = "Name of the application insights"
}

output "app_insights_connection_string" {
  value       = azurerm_application_insights.app_insights.connection_string
  description = "Connection string for Application Insights which has been deployed"
}

output "version_set_id" {
  value       = azurerm_api_management_api_version_set.version_set.id
  description = "ID of the APIM version set created"
}

output "app_service_plan_id" {
  value       = local.is_not_dev ? module.api_functions_asp[0].id : null
  description = "The premium tier App Service Plan ID provisioned once per environment"
}
