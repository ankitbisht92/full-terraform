variable "backends" {
  type = list(object({
    backend_pool_name  = string,
    route_name         = string,
    route_type         = string
    routes             = list(string),
    host_address       = string,
    accepted_protocols = list(string)
    enabled            = bool
  }))
  description = "Backends for the Front Door"
}

variable "cache_enabled" {
  type        = bool
  description = "Whether to enable caching on the forwarding rule"
  default     = false
}

variable "custom_frontends" {
  type = list(object({
    name                                    = string,
    host_name                               = string,
    web_application_firewall_policy_link_id = string
  }))
  description = "Optional custom frontend for the Front Door"
  default     = null
}

variable "health_check_interval" {
  type        = number
  description = "Backend health check interval (in seconds)"
  default     = 120
}

variable "health_check_method" {
  type        = string
  description = "HTTP method to use for the health check probe. Can be GET or HEAD"
  default     = "HEAD"
}

variable "health_check_protocol" {
  type        = string
  description = "Protocol to use for backend health checks (Http or Https)"
  default     = "Https"
}

variable "health_check_sample_size" {
  type        = number
  description = "Number of samples to consider for health check decisions"
  default     = 4
}

variable "health_check_success_samples" {
  type        = number
  description = "Number of health checks in a sample that must succeed for the backend to be considered healthy"
  default     = 2
}

variable "name" {
  type        = string
  description = "Name of the Front Door to create"
}

variable "resource_group" {
  type        = string
  description = "Resource group to deploy the Front Door into"
}

variable "web_application_firewall_policy_link_id" {
  type        = string
  description = "WAF policy to be attached to Azure Frontdoor"
  default     = null
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log analytics workspace id to send the diagnostic logs too"
}

variable "eventhub_name" {
  type        = string
  description = "Eventhub name to send the diagnostic logs to"
}

variable "eventhub_authorization_rule_id" {
  type        = string
  description = "Eventhub authorization rule id"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the resource"
  default     = {}
}

variable "retention_days" {
  type        = number
  description = "The retention days for logs and metrics."
}
