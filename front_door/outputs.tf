output "site_url" {
  description = "URL of the website"
  value       = "https://${trimsuffix(azurerm_dns_cname_record.front_door.fqdn, ".")}"
}

output "apim_url" {
  description = "APIM base url with path to API."
  value       = "https://${trimsuffix(azurerm_dns_cname_record.front_door.fqdn, ".")}/${var.api_path}/${var.api_version}"
}