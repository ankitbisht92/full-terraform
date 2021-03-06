variable "environment_prefix" {
  type        = string
  description = "The name of the environment to deploy the resource."
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
  description = "The resource group to deploy the resource."
}

variable "api_management_sku_name" {
  type        = string
  description = "SKU to start APIM with. Must match a valid APIM SKU from MS docs"
}

variable "location" {
  type        = string
  description = "Azure location to deploy resources into. Must be either 'uksouth' or 'ukwest'"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR block to assign to the APIM VNet"
}

variable "myaccount_signing_key" {
  type        = string
  description = "my accounts accesskey signing key"
  sensitive   = true
}

variable "xplan_app_id" {
  type        = string
  description = "Xplan Application Id"
  sensitive   = true
}

variable "xplan_username" {
  type        = string
  description = "Xplan basic auth username"
  sensitive   = true
}

variable "xplan_password" {
  type        = string
  description = "Xplan basic auth password"
  sensitive   = true
}

variable "myaccount_guest_username" {
  type        = string
  description = "myaccount guest username used for anonymous logins."
  sensitive   = true
}

variable "myaccount_guest_password" {
  type        = string
  description = "myaccount guest password used for anonymous logins."
  sensitive   = true
}

variable "private_dns_zone" {
  type        = string
  description = "The private DNS Zone for the APIM."
}

variable "public_dns_zones" {
  type = list(object({
    public_dns_parent_zone = string
    public_dns_child_zones = list(string)
  }))
  description = "The public DNS zone object containing parent and child DNS subzone for the subscription"
}

variable "dns_a_records" {
  type = map(object({
    name    = string
    records = list(string)
  }))
  description = "objects containing name and records to associate with the DNS A record."
}

variable "public_ns_record" {
  type = list(object({
    public_dns_zone       = string
    public_ns_record_name = string
    public_ns_name_server = list(string)
  }))
  description = "objects containing DNS zone and the subdomain required to be delegated"
}

variable "sg_rules" {
  type = list(object({
    name                       = string
    description                = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_address_prefix      = string
    source_port_range          = string
    destination_address_prefix = string
    destination_port_range     = number
  }))
  description = "The environment specific sg rules to be added to the security group."
}

variable "slack_security_alert_webhook_url" {
  type        = string
  description = "slack security alert web hook url"
  sensitive   = true
}

variable "api_backends" {
  type = map(object({
    name                       = string
    url                        = string
    validate_certificate_chain = bool
  }))
  description = "list of backend api urls"
}

variable "apim_routes" {
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
  description = "The environment specific routing rules. Routes specified here are applied at the APIM level."
}

variable "centralised_log_analytics_workspace_id" {
  type        = string
  description = "Log analytics workspace id to send the diagnostic logs too"
}

variable "is_zone_redundant" {
  type        = bool
  default     = false
  description = "Determines whether the App service plan is zone redundant."
}

variable "asp_capacity" {
  type        = number
  default     = 0
  description = "The number of workers to associate with this App Service Plan."
}
