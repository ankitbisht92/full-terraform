variable "tags" {
  type        = map(string)
  default     = {}
  description = "Non default tags for the resource."
}

variable "storage_account_name" {
  type        = string
  description = "The name for the static website hosting storage account."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource group to deploy the storage account."
}

variable "location" {
  type        = string
  description = "The Azure location to deploy the Storage Account."
}

variable "account_kind" {
  type        = string
  description = "The Storage Account kind."
}

variable "account_tier" {
  type        = string
  description = "The storage account tier."
}

variable "account_replication_type" {
  type        = string
  description = "The replication type for the storage account."
}

variable "cdn_profile_name" {
  type        = string
  description = "Name of the CDN profile to create the endpoint in"
}

variable "enable_https_traffic_only" {
  type        = bool
  default     = true
  description = "Should the storage account only allow https traffic?"
}

variable "index_path" {
  type        = string
  default     = "index.html"
  description = "The path to the index.html page."
}

variable "error_path" {
  type        = string
  default     = "error.html"
  description = "The path to the error.html page."
}

variable "csp_allowed_script_sources" {
  type        = string
  description = "Any allowed 'script-src' directives to be added to the CSP header in the CDN rules"
  default     = "'self'"
}

variable "csp_allowed_style_sources" {
  type        = string
  description = "Any allowed 'style-src' directives to be added to the CSP header in the CDN rules"
  default     = "'self'"
}

variable "csp_allowed_frame_sources" {
  type        = string
  description = "Any allowed 'frame-src' directives to be added to the CSP header in the CDN rules"
  default     = "'self'"
}

variable "csp_allowed_worker_sources" {
  type        = string
  description = "Any allowed 'worker-src' directives to be added to the CSP header in the CDN rules"
  default     = "'self'"
}

variable "public_dns_zone_name" {
  type        = string
  description = "The name of the public DNS zone"
  default     = ""
}

variable "public_dns_cname" {
  type        = string
  description = "The cname record mapped to the CDN"
  default     = ""
}

variable "dns_resource_group_name" {
  type        = string
  description = "The resource group name where the DNS public zones are hosted in, if left blank, any required DNS resource will be created in var.resource_group_name"
  default     = ""
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log analytics workspace id to send the diagnostic logs too"
}

variable "retention_days" {
  type        = number
  description = "The retention days for logs and metrics."
}

variable "cdn_delivery_rules" {
  type = list(object({
    name = string
    url_file_extension_conditions = list(object({
      operator         = string
      negate_condition = bool
      match_values     = list(string)
    }))
    url_path_conditions = list(object({
      operator         = string
      negate_condition = bool
      match_values     = list(string)
    }))
    url_rewrite_action = object({
      destination             = string
      source_pattern          = string
      preserve_unmatched_path = bool
    })
  }))
  description = "A list of CDN delivery rules. See https://docs.microsoft.com/en-us/azure/cdn/cdn-standard-rules-engine-reference"
  default     = []
}

variable "enable_storage_account_firewall" {
  description = "Whether to enable the network rule on the storage account to restrict access to only the CDN endpoint"
  type        = bool
  default     = true
}
