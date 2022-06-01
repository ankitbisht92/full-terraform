variable "apim_name" {
  type        = string
  description = "Name of the APIM to use for this deployment to create APIs in"
}

variable "apim_subnet_name" {
  type        = string
  description = "Name of the subnet which houses the APIM instance to connect to"
}

variable "fa_subnet_id" {
  type        = string
  default     = null
  description = "Function app subnet ID"
}

variable "apim_vnet_name" {
  type        = string
  description = "Name of the VNet which houses the APIM instance to connect to"
}

variable "app_insights_name" {
  type        = string
  description = "name of the Application insights"
}

variable "app_name" {
  type        = string
  default     = "digital-hybrid"
  description = "The name of the application"
}

variable "centralised_log_analytics_workspace_id" {
  type        = string
  description = "Log analytics workspace id to send the diagnostic logs too"
}

variable "environment_prefix" {
  type        = string
  description = "The name of the environment to deploy the resource."
}

variable "git_branch_name" {
  type        = string
  description = "Name of the Git branch, used as a tag on resources"
}

variable "location" {
  type        = string
  description = "Azure location to deploy resources into. Must be either 'uksouth' or 'ukwest'"
  default     = "UK South"
}

variable "projections_function_app_code_path" {
  type        = string
  default     = "./zips/projections.zip"
  description = "Path to the function app code."
}

variable "website_hostname" {
  type        = string
  description = "Hostname of the frontend website"
}

variable "resource_group_name" {
  type        = string
  description = "The of the resource group to deploy the resource"
}

variable "returns_function_app_code_path" {
  type        = string
  default     = "./zips/returns.zip"
  description = "Path to the returns function app code."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Non default tags for the resource"
}

variable "version_set_id" {
  type        = string
  description = "ID of the APIM version set to deploy APIs into"
}

variable "wrappers_function_app_code_path" {
  type        = string
  default     = "./zips/wrappers.zip"
  description = "Path to the wrappers function app code."
}

variable "myaccounts_aes_key" {
  type        = string
  default     = ""
  description = "Asymmetric key to encrypt profile creation credentials"
  sensitive   = true
}

variable "myaccounts_aes_key_vector" {
  type        = string
  default     = ""
  description = "Asymmetric key vector to encrypt profile creation credentials"
  sensitive   = true
}

variable "cors_allowed_origins" {
  type        = list(string)
  default     = []
  description = "List of origins to allow for CORS"
}

variable "cors_allowed_origins_xplan" {
  type        = list(string)
  default     = []
  description = "List of origins to allow for CORS of xplan endpoints"
}

variable "app_service_plan_id" {
  type        = string
  default     = null
  description = "The ID of the premium App Service Plan provisioned once per environment"
}

variable "elastic_instance_minimum" {
  type        = number
  default     = null
  description = "The minimum number of instances to create. This must be greater than zone redundancy capacity."
}

variable "cname_record" {
  type        = string
  default     = null
  description = "the cname record for the staging frontend endpoint"
}

variable "public_dns_zone_name" {
  type        = string
  default     = null
  description = "the public dns zone name for the staging frontend endpoint"
} 