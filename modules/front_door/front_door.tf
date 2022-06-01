resource "azurerm_frontdoor" "this" {
  enforce_backend_pools_certificate_name_check = true
  name                                         = var.name
  resource_group_name                          = var.resource_group

  dynamic "backend_pool" {
    for_each = [for backend in var.backends : backend if backend.route_type != "redirect"]
    content {
      name                = backend_pool.value.backend_pool_name
      health_probe_name   = "HealthProbe"
      load_balancing_name = "LoadBalancer"

      backend {
        address     = backend_pool.value.host_address
        host_header = backend_pool.value.host_address
        http_port   = 80
        https_port  = 443
        enabled     = backend_pool.value.enabled
      }
    }
  }

  backend_pool_health_probe {
    name                = "HealthProbe"
    protocol            = var.health_check_protocol
    interval_in_seconds = var.health_check_interval
    probe_method        = var.health_check_method
  }

  backend_pool_load_balancing {
    name                        = "LoadBalancer"
    sample_size                 = var.health_check_sample_size
    successful_samples_required = var.health_check_success_samples
  }

  dynamic "frontend_endpoint" {
    for_each = local.front_ends
    content {
      name                                    = frontend_endpoint.value.name
      host_name                               = frontend_endpoint.value.host_name
      web_application_firewall_policy_link_id = frontend_endpoint.value.web_application_firewall_policy_link_id
    }
  }

  dynamic "routing_rule" {
    for_each = [for backend in var.backends : backend if backend.route_type == "forward"]
    content {
      name               = routing_rule.value.route_name
      accepted_protocols = routing_rule.value.accepted_protocols
      patterns_to_match  = routing_rule.value.routes
      frontend_endpoints = local.frontend_endpoints

      forwarding_configuration {
        backend_pool_name = routing_rule.value.backend_pool_name
        cache_enabled     = var.cache_enabled
      }
    }
  }

  dynamic "routing_rule" {
    for_each = [for backend in var.backends : backend if backend.route_type == "redirect"]
    content {
      name               = routing_rule.value.route_name
      accepted_protocols = routing_rule.value.accepted_protocols
      patterns_to_match  = routing_rule.value.routes
      frontend_endpoints = local.frontend_endpoints

      redirect_configuration {
        custom_host       = routing_rule.value.host_address
        redirect_type     = "PermanentRedirect"
        redirect_protocol = "HttpsOnly"
      }
    }
  }

  tags = merge(map("tf_module_path", "./terraform/modules/front_door"), var.tags)
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${var.name}-diag-settings"
  target_resource_id         = azurerm_frontdoor.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  eventhub_name = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id

  log {
    category = "FrontdoorAccessLog"
    enabled  = true
    retention_policy {
      days    = var.retention_days
      enabled = true
    }
  }

  log {
    category = "FrontdoorWebApplicationFirewallLog"
    enabled  = true
    retention_policy {
      days    = var.retention_days
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      days    = var.retention_days
      enabled = true
    }
  }
}
