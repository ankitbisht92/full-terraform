output "apim_gateway_url" {
  value       = data.azurerm_api_management.apim.gateway_url
  description = "The gateway URL for the APIM."
}

output "frontend_cdn_endpoint_name" {
  value       = module.front_end.cdn_endpoint_name
  description = "The Gatsby App web CDN endpoint name."
}

output "frontend_cdn_profile_name" {
  value       = local.website_cdn_profile
  description = "The Gatsby App web CDN profile name."
}

output "frontend_web_host" {
  value       = module.front_end.web_host
  description = "The Gatsby app static web hostname"
}

output "frontend_static_web_url" {
  value       = "https://${module.front_end.web_host}"
  description = "The Gatsby App static web url."
}

output "storybook_web_endpoint" {
  value       = !local.is_prod ? module.storybook[0].web_endpoint : null
  description = "The storybook web endpoint."
}

output "storybook_cdn_endpoint_name" {
  value       = !local.is_prod ? module.storybook[0].cdn_endpoint_name : null
  description = "The storybook CDN endpoint name."
}

output "storybook_cdn_profile_name" {
  value       = !local.is_prod ? local.storybook_cdn_profile : null
  description = "The storybook CDN profile name."
}

output "frontend_storage_account_name" {
  value       = module.front_end.name
  description = "Name of the storage account hosting the Gatsby App."
}

output "storybook_storage_account_name" {
  value       = !local.is_prod ? module.storybook[0].name : null
  description = "Name of the storage account hosting the storybook."
}

output "myaccounts_home_url" {
  value       = local.is_prod ? "https://select.bestinvest.co.uk/myportfolio" : "https://select.demo2.bestinvest.co.uk/myportfolio"
  description = "My Accounts Home Page"
}

output "gtm_env_auth" {
  value       = var.gtm_env_auth
  description = "Environment auth identifier for Google Tag Manager"
}

output "gtm_env_preview" {
  value       = var.gtm_env_preview
  description = "Environment preview identifier for Google Tag Manager"
}

output "website_hostname" {
  //value       = local.is_dev ? module.front_end.web_endpoint : "https://${var.cname_record}.${var.public_dns_zone_name}"
  value       = local.is_dev ? module.front_end.web_endpoint : "https://${var.cname_record_secondary}.${var.public_dns_zone_name_secondary}"
  description = "Hostname of the deployed frontend"
}

output "public_dns_zone_name" {
  value       = var.public_dns_zone_name
  description = "The public dns zone name."
}

output "cname_record" {
  value       = var.cname_record
  description = "The cname record for Front Door."
}
