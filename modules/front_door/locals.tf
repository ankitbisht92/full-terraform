locals {
  front_ends = concat(
    [
      {
        name                                    = "default",
        host_name                               = "${var.name}.azurefd.net",
        web_application_firewall_policy_link_id = var.web_application_firewall_policy_link_id
      }
    ],
    var.custom_frontends != null ? var.custom_frontends : []
  )

  frontend_endpoints = [for frontend in local.front_ends : frontend.name]
}
