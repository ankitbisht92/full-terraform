resource "azurerm_api_management_api_version_set" "version_set" {
  name                = "vs-${local.short_location}-${var.environment_prefix}-${var.app_name}"
  display_name        = "Digital Hybrid ${title(var.environment_prefix)} API"
  resource_group_name = var.resource_group_name
  api_management_name = module.apim.name
  versioning_scheme   = "Segment"
}
