variable "environment_prefix" {
  type        = string
  description = "The name of the environment to deploy the resource."
}

variable "git_branch_name" {
  type        = string
  description = "Name of the Git branch, used as a tag on resources"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Non default tags for the resource."
}

variable "app_name" {
  type        = string
  default     = "digital-hybrid"
  description = "The name of the application."
}

variable "resource_group_name" {
  type        = string
  description = "The of the resource group to deploy the resource."
}

variable "location" {
  type        = string
  description = "Azure location to deploy resources into. Must be either 'uksouth' or 'ukwest'"
}

variable "gtm_env_auth" {
  type        = string
  description = "Environment auth identifier (not a secret) for Google Tag Manager found in the GTM admin console."
}

variable "gtm_env_preview" {
  type        = string
  description = "Environment preview identifier (not a secret) for Google Tag Manager found in the GTM admin console."
}

variable "apim_name" {
  type        = string
  description = "Name of the APIM to use for this deployment to create APIs in"
}

variable "cdn_profile_website_name" {
  type        = string
  description = "Name of the CDN profile to create endpoints on for the website"
}

variable "cdn_profile_storybook_name" {
  type        = string
  description = "Name of the CDN profile to create endpoints on for storybook"
}

variable "cdn_profile_website_name_1" {
  type        = string
  description = "Name of the second CDN profile for the frontend website created for the development environment"
  default     = null
}

variable "cdn_profile_storybook_name_1" {
  type        = string
  description = "Name of the second CDN profile for storybook created for the development environment"
  default     = null
}

variable "is_pr_num_odd" {
  type        = bool
  description = "Is the pull request number odd"
  default     = true
}

variable "app_insights_name" {
  type        = string
  description = "name of the Application insights"
}

variable "public_dns_zone_name" {
  type        = string
  description = "The name of the public DNS zone"
}

variable "cname_record" {
  type        = string
  default     = null
  description = "The CNAME used with the public DNS zone for front door. Defaults to null in the dev environment."
}

variable "public_dns_zone_name_secondary" {
  type        = string
  default     = null
  description = "The name of the public DNS zone secondary"
}

variable "cname_record_secondary" {
  type        = string
  default     = null
  description = "The CNAME used with the public DNS zone for front door. Defaults to null in the dev environment."
}
variable "dns_resource_group_name" {
  type        = string
  description = "Resource group that hosts the public DNS zone"
}

variable "centralised_log_analytics_workspace_id" {
  type        = string
  description = "Log analytics workspace id to send the diagnostic logs too"
}
