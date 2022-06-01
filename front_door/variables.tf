variable "environment_prefix" {
  type        = string
  description = "The name of the environment to deploy the resource"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group to deploy the resource"
}

variable "cdn_endpoint_host" {
  type        = string
  description = "CDN endpoint to use as the backend for the front door"
}

variable "public_dns_zone_name" {
  type        = string
  description = "DNS Zone to create the CNAME record in"
}

variable "cname_record" {
  type        = string
  description = "The CNAME used with the public DNS zone for front door. Defaults to null in the dev environment."
}

variable "public_dns_zone_name_secondary" {
  type = string
  description = "DNS Zone to create the CNAME record in for testing"
}

variable "cname_record_secondary" {
  type        = string
  description = "The CNAME used with the public DNS zone for front door. Defaults to null in the dev environment. for testing."
}

variable "custom_frontend_name" {
  type = string
  description = "the custom frontend name for the additional frontend endpoint"
}

variable "tags" {
  type        = map(string)
  description = "Tags to add to all resources"
  default     = {}
}

variable "is_waf_enabled" {
  type        = bool
  description = "should WAF policy be created and attached to frontdoor"
  default     = true
}

variable "centralised_log_analytics_workspace_id" {
  type        = string
  description = "Log analytics workspace id to send the diagnostic logs too"
}

variable "soc_eventhub_name" {
  type        = string
  description = "Eventhub name to send the diagnostic logs to"
}

variable "soc_eventhub_authorization_rule_id" {
  type        = string
  description = "Eventhub authorization rule id"
}

variable "apim_name" {
  type        = string
  description = "The name of APIM instance."
}

variable "api_path" {
  type        = string
  description = "The path to API in APIM."
}

variable "api_version" {
  type        = string
  description = "The version of the API in APIM."
}
