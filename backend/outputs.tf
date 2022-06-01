output "api_base_url" {
  value       = local.is_not_dev ? "${var.website_hostname}/${module.apim_api.path}/${local.api_version}" : local.apim_base_url
  description = "Outputs the url to APIM from front door for non dev environments and the APIM gateway url for dev."
}

output "api_endpoints" {
  value       = jsonencode(local.api_endpoints)
  description = "All the resouces URLs that can be accessed from the base URL."
}

output "api_name" {
  value       = local.api_name
  description = "The name of the API in APIM."
}

output "api_path" {
  value       = module.apim_api.path
  description = "The name of the API in APIM."
}

output "api_version" {
  value       = local.api_version
  description = "The name of the API in APIM."
}
