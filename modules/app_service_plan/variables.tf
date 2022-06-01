variable "name" {
  type        = string
  description = "The name of the App Service Plan."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group to deploy the App Service Plan."
}

variable "location" {
  type        = string
  description = "The location to deploy the App Service Plan."
}

variable "kind" {
  type        = string
  description = "The kind of App Service Plan to deploy."
}

variable "tier" {
  type        = string
  description = "The tier for the App Service Plan."
}

variable "size" {
  type        = string
  description = "The size of the App Service Plan."
}

variable "reserved" {
  type        = bool
  description = "Whether this ASP should be reserved"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Non default tags for the resource."
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

variable "zone_redundant" {
  type        = bool
  default     = null
  description = "Determines whether the App Service Plan is Zone Redundant."
}

variable "capacity" {
  type        = number
  default     = null
  description = "The number of workers to associate with this App Service Plan."
}

variable "per_site_scaling" {
  type        = bool
  default     = null
  description = "Allows Apps in this ASP to scale independantly rather than scaling all the Apps at once."
}