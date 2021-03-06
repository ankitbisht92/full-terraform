variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy function app into"
}

variable "location" {
  type        = string
  description = "Azure Location to deploy function app into. Must be in the same location as desired resource group"
}

variable "name" {
  type        = string
  description = "Name of the function app to be deployed"
}

variable "storage_account_name" {
  type        = string
  description = "Prefix to append to the start of the function app storage account"
}

variable "app_code_path" {
  type        = string
  description = "Local path to function app zip code"
}

variable "app_service_plan_id" {
  type        = string
  description = "The ID of the app service plan to deploy function app into"
}

variable "os_type" {
  type        = string
  description = "`linux` for Linux derivatives, or an `null` for Windows"
}

variable "node_version" {
  type        = string
  description = "Version of node to run. Run `az webapp list-runtimes --linux` to get possible versions"
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "ID of the subnet to allow ingress traffic from for this function app"
}

variable "tags" {
  description = "Tags to apply to resources created by this module"
  default     = {}
  type        = map(string)
}

variable "app_insights_instrumentation_key" {
  type        = string
  description = "Application insights instrumentation key"
}

variable "app_settings" {
  type        = map(string)
  default     = {}
  description = "Custom app settings to apply to the function app"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log analytics workspace id to send the diagnostic logs too"
  default     = null
}

variable "retention_days" {
  type        = number
  description = "The retention days for logs and metrics."
}

variable "elastic_instance_minimum" {
  type        = number
  description = "The minimum number of instances to create. This must be greater than zone redundancy capacity."
}

variable "apim_subnet_id" {
  type        = string
  description = "The ID of the APIM subnet"
}

variable "requires_vnet_integration" {
  type        = bool
  default     = false
  description = "Determines whether the function app must be put in a Vnet"
}
