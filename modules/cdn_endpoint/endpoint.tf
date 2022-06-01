resource "azurerm_cdn_endpoint" "storage_account" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = "Global"
  profile_name              = var.cdn_profile_name
  origin_host_header        = var.origin_hostname
  is_http_allowed           = false
  is_compression_enabled    = true
  optimization_type         = "GeneralWebDelivery"
  content_types_to_compress = ["application/javascript", "text/css", "text/html", "application/x-javascript", "application/json", "application/xml", "text/plain", "application/octet-stream", "image/png", "image/jpeg", "image/svg+xml"]
  origin {
    host_name = var.origin_hostname
    name      = var.origin_name
  }

  // Globally add security headers to all outgoing responses
  global_delivery_rule {
    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security
    modify_response_header_action {
      action = "Append"
      name   = "Strict-Transport-Security"
      value  = "max-age=31536000; includeSubDomains"
    }
    // https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP
    modify_response_header_action {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = "script-src ${var.csp_allowed_script_sources}; style-src ${var.csp_allowed_style_sources}; frame-src ${var.csp_allowed_frame_sources}; worker-src ${var.csp_allowed_worker_sources};"
    }
    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
    modify_response_header_action {
      action = "Append"
      name   = "X-Frame-Options"
      value  = "SAMEORIGIN"
    }
    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options
    modify_response_header_action {
      action = "Append"
      name   = "X-Content-Type-Options"
      value  = "nosniff"
    }
    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy
    modify_response_header_action {
      action = "Append"
      name   = "Referrer-Policy"
      value  = "same-origin"
    }
    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Feature-Policy
    modify_response_header_action {
      action = "Append"
      name   = "Permissions-Policy"
      value  = "payment=(self), geolocation=(self)"
    }
  }

  // Redirect all HTTP requests to HTTPS
  delivery_rule {
    name  = "BlockHttp"
    order = 1
    request_scheme_condition {
      operator     = "Equal"
      match_values = ["HTTP"]
    }
    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }

  dynamic "delivery_rule" {
    for_each = var.delivery_rules
    content {
      name  = delivery_rule.value["name"]
      order = delivery_rule.key + 2 // Start at 2. The "BlockHttp" rule defined above has order = 1
      dynamic "url_file_extension_condition" {
        for_each = delivery_rule.value["url_file_extension_conditions"]
        content {
          operator         = url_file_extension_condition.value["operator"]
          negate_condition = url_file_extension_condition.value["negate_condition"]
          match_values     = url_file_extension_condition.value["match_values"]
        }
      }
      dynamic "url_path_condition" {
        for_each = delivery_rule.value["url_path_conditions"]
        content {
          operator         = url_path_condition.value["operator"]
          negate_condition = url_path_condition.value["negate_condition"]
          match_values     = url_path_condition.value["match_values"]
        }
      }
      url_rewrite_action {
        destination             = delivery_rule.value.url_rewrite_action.destination
        source_pattern          = delivery_rule.value.url_rewrite_action.source_pattern
        preserve_unmatched_path = delivery_rule.value.url_rewrite_action.preserve_unmatched_path
      }
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag-settings"
  target_resource_id         = azurerm_cdn_endpoint.storage_account.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "CoreAnalytics"
    enabled  = true
    retention_policy {
      days    = var.retention_days
      enabled = true
    }
  }
}