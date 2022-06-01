variable "name" {
  type        = string
  description = "Name to assign to this endpoint"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to create this endpoint in"
}

variable "cdn_profile_name" {
  type        = string
  description = "Name of the CDN profile to create this endpoint in"
}

variable "origin_hostname" {
  type        = string
  description = "Name of the origin resource to use as the target of this endpoint"
}

variable "origin_name" {
  type        = string
  description = "Name to use for the origin (target) of this endpoint"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the endpoint"
}

variable "csp_allowed_script_sources" {
  type        = string
  description = "Any allowed 'script-src' directives to be added to the CSP header"
  default     = "'self'"
}

variable "csp_allowed_style_sources" {
  type        = string
  description = "Any allowed 'style-src' directives to be added to the CSP header"
  default     = "'self'"
}

variable "csp_allowed_frame_sources" {
  type        = string
  description = "Any allowed 'frame-src' directives to be added to the CSP header"
  default     = "'self'"
}

variable "csp_allowed_worker_sources" {
  type        = string
  description = "Any allowed 'worker-src' directives to be added to the CSP header"
  default     = "'self'"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log analytics workspace id to send the diagnostic logs too"
}

variable "retention_days" {
  type        = number
  description = "The retention days for logs and metrics."
}

variable "delivery_rules" {
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