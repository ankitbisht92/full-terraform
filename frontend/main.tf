module "front_end" {
  source                          = "../modules/static_website_with_cdn"
  storage_account_name            = "st${local.short_location}tsw${replace(var.environment_prefix, "-", "")}dh"
  resource_group_name             = data.azurerm_resource_group.resource_group.name
  location                        = data.azurerm_resource_group.resource_group.location
  account_kind                    = "StorageV2"
  account_replication_type        = "GRS"
  account_tier                    = "Standard"
  cdn_profile_name                = local.website_cdn_profile
  dns_resource_group_name         = var.dns_resource_group_name
  enable_storage_account_firewall = local.is_not_dev

  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id


  csp_allowed_script_sources = "'self' 'unsafe-inline' 'unsafe-eval' *.tiqcdn.com *.tealiumiq.com *.googletagmanager.com *.hotjar.com *.google-analytics.com *.worldpay.com *.getsitecontrol.com *.fullstory.com *.appcues.com *.gstatic.com *.adalyser.com *.recaptcha.google.com recaptcha.net/recaptcha/"
  csp_allowed_style_sources  = "'self' 'unsafe-inline' *.worldpay.com *.appcues.com fonts.googleapis.com fonts.google.com *.recaptcha.google.com *.gstatic.com recaptcha.net/recaptcha/"
  csp_allowed_frame_sources  = "'self' 'unsafe-inline' *.worldpay.com *.hotjar.com calendly.com *.appcues.com *.recaptcha.google.com *.gstatic.com recaptcha.net/recaptcha/"
  csp_allowed_worker_sources = "'self' blob:"
  retention_days             = lookup(local.log_retention, var.environment_prefix, lookup(local.log_retention, local.is_dev ? "dev" : "prod"))

  cdn_delivery_rules = [
    // Redirect all requests that...
    //
    //  * do not specify a file extension
    //    AND
    //  * Do not begin with a path to one of the app's pages (as configured by Gatsby)
    //
    // ...to /index.html. That will then render the login page, and if the user is already logged in
    // then they will be routed to /my-account.
    //
    // Requests for images, Javascript, fonts etc will not be rewritten, because they will have a
    // file extension.
    //
    // Each of the paths specified should be passed to the app as-is, because the app has a
    // <path>/index.html page for each.
    {
      name = "RewriteSPARequests"
      url_file_extension_conditions = [
        {
          operator         = "LessThan"
          negate_condition = false
          match_values     = ["1"]
        }
      ]
      url_path_conditions = [
        {
          operator         = "BeginsWith"
          negate_condition = true
          match_values     = ["/404", "/activation", "/error", "/login", "/my-account", "/onboarding", "/reset-login", "/reset-login-confirmation"]
        }
      ]
      url_rewrite_action = {
        destination             = "/index.html"
        source_pattern          = "/"
        preserve_unmatched_path = false
      }
    },
    // If the URL path begins with "/my-account/" then rewrite to "/my-account" and let the app render
    // the appropriate page (using Reach Router)
    {
      name                          = "MyAccount"
      url_file_extension_conditions = []
      url_path_conditions = [
        {
          operator         = "BeginsWith"
          negate_condition = false
          match_values     = ["/my-account/"]
        }
      ]
      url_rewrite_action = {
        destination             = "/my-account"
        source_pattern          = "/"
        preserve_unmatched_path = false
      }
    },
    // If the URL path begins with "/onboarding/" then rewrite to "/onboarding" and let the app render
    // the appropriate page (using Reach Router)
    {
      name                          = "Onboarding"
      url_file_extension_conditions = []
      url_path_conditions = [
        {
          operator         = "BeginsWith"
          negate_condition = false
          match_values     = ["/onboarding/"]
        }
      ]
      url_rewrite_action = {
        destination             = "/onboarding"
        source_pattern          = "/"
        preserve_unmatched_path = false
      }
    }
  ]

  tags = merge(var.tags, local.default_tags)
}

module "storybook" {
  count                           = !local.is_prod ? 1 : 0
  source                          = "../modules/static_website_with_cdn"
  storage_account_name            = "st${local.short_location}tsw${replace(var.environment_prefix, "-", "")}dhsb"
  resource_group_name             = data.azurerm_resource_group.resource_group.name
  location                        = data.azurerm_resource_group.resource_group.location
  account_kind                    = "StorageV2"
  account_replication_type        = "GRS"
  account_tier                    = "Standard"
  cdn_profile_name                = local.storybook_cdn_profile
  enable_storage_account_firewall = local.is_not_dev

  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id

  csp_allowed_script_sources = "'self' 'unsafe-inline' 'unsafe-eval' *.tiqcdn.com *.tealiumiq.com *.googletagmanager.com *.hotjar.com *.google-analytics.com *.getsitecontrol.com *.fullstory.com"
  csp_allowed_style_sources  = "'self' 'unsafe-inline'"
  retention_days             = lookup(local.log_retention, var.environment_prefix, lookup(local.log_retention, local.is_dev ? "dev" : "prod"))
  tags                       = merge(var.tags, local.default_tags)
}

resource "azurerm_dashboard" "application_metrics_dashboard" {
  count               = local.is_not_dev ? 1 : 0
  name                = "${var.environment_prefix}-${var.app_name}-application-metrics-dashboard"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  tags                = local.default_tags
  dashboard_properties = templatefile("../modules/dashboard_schema/dashboard-schema.json",
    {
      apim_name      = data.azurerm_api_management.apim.name,
      apim_id        = data.azurerm_api_management.apim.id,
      ai_id          = data.azurerm_application_insights.app_insights.id,
      ai_name        = data.azurerm_application_insights.app_insights.name,
      cdn_web_id     = data.azurerm_cdn_profile.cdn_profile_website.id
      cdn_web_name   = var.cdn_profile_website_name
      dashboard_name = "${var.environment_prefix}-${var.app_name}-application-metrics-dashboard"
  })
}
