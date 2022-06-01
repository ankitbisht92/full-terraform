// Agreed with InfoSec to run the policy in detection mode to fine tune the policy
resource "azurerm_frontdoor_firewall_policy" "frontdoor" {
  count               = var.is_waf_enabled ? 1 : 0
  name                = "waf${replace(local.front_door_name, "-", "")}policy"
  resource_group_name = data.azurerm_resource_group.rg.name
  enabled             = true
  mode                = "Prevention"
  managed_rule {
    type    = "Microsoft_DefaultRuleSet"
    version = "1.1"
    exclusion {
      match_variable = "RequestCookieNames"
      operator       = "Contains"
      selector       = "MyAccountsApi"
    }
    exclusion {
      match_variable = "RequestCookieNames"
      operator       = "Contains"
      selector       = "OisApi"
    }
    exclusion {
      match_variable = "RequestCookieNames"
      operator       = "Contains"
      selector       = "OnlineApi"
    }
    exclusion {
      match_variable = "RequestHeaderNames"
      operator       = "Contains"
      selector       = "Authorization"
    }
    exclusion {
      match_variable = "RequestCookieNames"
      operator       = "Contains"
      selector       = "MYACCOUNTSSSO"
    }
    exclusion {
      match_variable = "RequestCookieNames"
      operator       = "Contains"
      selector       = "mp_8d307a26a2f7ff81e58b4fd15e7172e4_mixpanel"
    }
    exclusion {
      match_variable = "RequestCookieNames"
      operator       = "Contains"
      selector       = "optimizelyBuckets"
    }
    exclusion {
      match_variable = "RequestCookieNames"
      operator       = "Contains"
      selector       = "apitokens"
    }
    exclusion {
      match_variable = "RequestCookieNames"
      operator       = "Contains"
      selector       = "maud"
    }
    exclusion {
      match_variable = "RequestCookieNames"
      operator       = "Contains"
      selector       = "ai_user"
    }
    exclusion {
      match_variable = "RequestCookieNames"
      operator       = "Contains"
      selector       = "OISAccounts"
    }
    exclusion {
      match_variable = "QueryStringArgNames"
      operator       = "Contains"
      selector       = "lastId"
    }
    exclusion {
      match_variable = "RequestCookieNames"
      operator       = "Contains"
      selector       = "ai_session"
    }
    # TODO: Investigate if this rule can be further restricted, updated to log to enable legitimate traffic post launch
    override {
      rule_group_name = "XSS"
      rule {
        rule_id = "941101"
        enabled = true
        action  = "Log"
      }
    }
  }
  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
  }
  tags = merge(var.tags, local.default_tags)
}

module "front_door" {
  source         = "../modules/front_door"
  resource_group = data.azurerm_resource_group.rg.name
  name           = local.front_door_name
  backends = [
    {
      backend_pool_name  = "cdn-backend",
      route_name         = "cdn",
      route_type         = "forward",
      routes             = ["/*"],
      host_address       = var.cdn_endpoint_host,
      accepted_protocols = ["Https"],
      enabled            = true
    },
    {
      backend_pool_name  = "apim-backend",
      route_name         = "apim",
      route_type         = "forward",
      routes             = ["/${var.api_path}/*"],
      host_address       = local.apim_hostname,
      accepted_protocols = ["Https"],
      enabled            = true
    },
    {
      backend_pool_name  = "cdn-backend",
      route_name         = "redirect-http-to-https",
      route_type         = "redirect",
      routes             = ["/*"],
      host_address       = null,
      accepted_protocols = ["Http"],
      enabled            = true
    },
  ]
  health_check_interval                   = 10
  health_check_sample_size                = 2
  health_check_success_samples            = 1
  web_application_firewall_policy_link_id = var.is_waf_enabled ? azurerm_frontdoor_firewall_policy.frontdoor[0].id : null
  custom_frontends = [{
    name                                    = local.custom_frontend_name,
    host_name                               = trimsuffix(azurerm_dns_cname_record.front_door.fqdn, "."),
    web_application_firewall_policy_link_id = var.is_waf_enabled ? azurerm_frontdoor_firewall_policy.frontdoor[0].id : null
 },
 {
    name                                    = var.custom_frontend_name,
    host_name                               = trimsuffix(azurerm_dns_cname_record.front_door_secondary.fqdn, "."),
    web_application_firewall_policy_link_id = var.is_waf_enabled ? azurerm_frontdoor_firewall_policy.frontdoor[0].id : null
  }]

  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id
  eventhub_name = var.soc_eventhub_name
  eventhub_authorization_rule_id = var.soc_eventhub_authorization_rule_id
  retention_days             = lookup(local.log_retention, var.environment_prefix)

  tags       = merge(var.tags, local.default_tags)
  depends_on = [azurerm_dns_cname_record.front_door]
}

resource "azurerm_dns_cname_record" "front_door" {
  name                = var.cname_record
  resource_group_name = var.resource_group_name
  zone_name           = var.public_dns_zone_name
  ttl                 = 3600
  record              = "${local.front_door_name}.azurefd.net"
  tags                = merge(var.tags, local.default_tags)
}

resource "azurerm_dns_cname_record" "front_door_secondary" {
  name                = var.cname_record_secondary
  resource_group_name = var.resource_group_name
  zone_name           = var.public_dns_zone_name_secondary
  ttl                 = 3600
  record              = "${local.front_door_name}.azurefd.net"
  tags                = merge(var.tags, local.default_tags)
}
  
// TODO: Replace hardcoded endpoint ID with module.front_door.frontend_endpoints[local.custom_frontend_name] once this
// bug is fixed: https://github.com/hashicorp/terraform-provider-azurerm/issues/10504
resource "azurerm_frontdoor_custom_https_configuration" "custom_https" {
  custom_https_provisioning_enabled = true
  frontend_endpoint_id              = "${module.front_door.id}/frontendEndpoints/${local.custom_frontend_name}"

  custom_https_configuration {
    certificate_source = "FrontDoor"
  }
}

resource "azurerm_frontdoor_custom_https_configuration" "custom_https_secondary" {
  custom_https_provisioning_enabled = true
  frontend_endpoint_id              = "${module.front_door.id}/frontendEndpoints/${var.custom_frontend_name}"

  custom_https_configuration {
    certificate_source = "FrontDoor"
  }

}

