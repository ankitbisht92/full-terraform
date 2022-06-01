resource "azurerm_virtual_network" "this" {
  name                = "vnet-${local.short_location}-${var.environment_prefix}-${var.app_name}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  address_space       = [var.vnet_cidr]
  tags                = merge(local.default_tags, var.tags)
}

resource "azurerm_monitor_diagnostic_setting" "network" {
  name                       = "${azurerm_virtual_network.this.name}-diag-settings"
  target_resource_id         = azurerm_virtual_network.this.id
  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      days    = lookup(local.log_retention, var.environment_prefix)
      enabled = true
    }
  }

  log {
    category = "VMProtectionAlerts"
    enabled  = false

    retention_policy {
      days    = local.log_retention.turned_off
      enabled = false
    }
  }
}

resource "azurerm_subnet" "apim_external_subnet" {
  name                 = "snet-${local.short_location}-${var.environment_prefix}-${var.app_name}"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [local.subnet_cidr.apim_external_subnet_cidr]
  service_endpoints    = ["Microsoft.Web"]
}

resource "azurerm_subnet" "private_link_subnet" {
  name                                           = "snet-private-link-${local.short_location}-${var.environment_prefix}-${var.app_name}"
  resource_group_name                            = data.azurerm_resource_group.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.this.name
  address_prefixes                               = [local.subnet_cidr.private_link_subnet_cidr]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_network_security_group" "private_link_nsg" {
  name                = "sg-${local.short_location}-${var.environment_prefix}-${var.app_name}-pl"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

  security_rule {
    name                       = "Inbound-VNET"
    description                = "Allows ingress from VNET"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    access                     = "Allow"
    priority                   = 100
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = local.subnet_cidr.private_link_subnet_cidr
    destination_port_range     = "443"
  }

  tags = merge(local.default_tags, var.tags)
}

resource "azurerm_subnet_network_security_group_association" "private_link_nsg_association" {
  network_security_group_id = azurerm_network_security_group.private_link_nsg.id
  subnet_id                 = azurerm_subnet.private_link_subnet.id
}

resource "azurerm_network_security_group" "apim_security_group" {
  name                = "sg-${local.short_location}-${var.environment_prefix}-${var.app_name}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

  security_rule {
    name                       = "Inbound-web"
    description                = "Allows ingress to port 443 from the internet"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    access                     = "Allow"
    priority                   = 100
    source_address_prefix      = "Internet"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "Inbound-API-Management"
    description                = "Allows ingress to port 3443 from API Management"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    access                     = "Allow"
    priority                   = 101
    source_address_prefix      = "ApiManagement"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
    destination_port_range     = "3443"
  }

  security_rule {
    name                       = "Outbound-Azure-storage"
    description                = "Allows egress on port 443 to Azure storage"
    direction                  = "Outbound"
    protocol                   = "Tcp"
    access                     = "Allow"
    priority                   = 102
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "Storage"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "Outbound-App-Service"
    description                = "Allows egress on port 443 to Azure Web Apps"
    direction                  = "Outbound"
    protocol                   = "Tcp"
    access                     = "Allow"
    priority                   = 103
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "AppService"
    destination_port_range     = "443"
  }

  # Used to provision environment specific sg rules.
  dynamic "security_rule" {
    for_each = var.sg_rules != [] ? var.sg_rules : []
    content {
      name                       = security_rule.value.name
      description                = security_rule.value.description
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_address_prefix      = security_rule.value.source_address_prefix
      source_port_range          = security_rule.value.source_port_range
      destination_address_prefix = security_rule.value.destination_address_prefix
      destination_port_range     = security_rule.value.destination_port_range
    }
  }

  tags = merge(local.default_tags, var.tags)
}

resource "azurerm_monitor_diagnostic_setting" "private_link_security_group" {
  name                       = "${azurerm_network_security_group.private_link_nsg.name}-diag-settings"
  target_resource_id         = azurerm_network_security_group.private_link_nsg.id
  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id

  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true
    retention_policy {
      enabled = true
      days    = lookup(local.log_retention, var.environment_prefix)
    }
  }

  log {
    category = "NetworkSecurityGroupRuleCounter"
    enabled  = true
    retention_policy {
      enabled = true
      days    = lookup(local.log_retention, var.environment_prefix)
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "security_group" {
  name                       = "${azurerm_network_security_group.apim_security_group.name}-diag-settings"
  target_resource_id         = azurerm_network_security_group.apim_security_group.id
  log_analytics_workspace_id = var.centralised_log_analytics_workspace_id

  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true
    retention_policy {
      enabled = true
      days    = lookup(local.log_retention, var.environment_prefix)
    }
  }

  log {
    category = "NetworkSecurityGroupRuleCounter"
    enabled  = true
    retention_policy {
      enabled = true
      days    = lookup(local.log_retention, var.environment_prefix)
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "apim_external_subnet" {
  network_security_group_id = azurerm_network_security_group.apim_security_group.id
  subnet_id                 = azurerm_subnet.apim_external_subnet.id
}

resource "azurerm_route_table" "apim_external_route_table" {
  name                = "apim_external_route_table"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

  # Used to setup environment specific routing rules.
  dynamic "route" {
    for_each = var.apim_routes != [] ? var.apim_routes : []
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }

  tags = merge(local.default_tags, var.tags)
}

resource "azurerm_subnet_route_table_association" "apim_external_subnet_rt" {
  subnet_id      = azurerm_subnet.apim_external_subnet.id
  route_table_id = azurerm_route_table.apim_external_route_table.id
}

resource "azurerm_subnet" "fa_subnet" {
  count                = local.is_not_dev ? 1 : 0
  name                 = "snet-${local.short_location}-${var.environment_prefix}-${var.app_name}-fa"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [local.subnet_cidr.fa_subnet_cidr]

  delegation {
    name = "fa-service-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_network_security_group" "fa_security_group" {
  count               = local.is_not_dev ? 1 : 0
  name                = "sg-${local.short_location}-${var.environment_prefix}-${var.app_name}-fa"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

  security_rule {
    name                       = "Inbound-from-APIM"
    description                = "Allow ingress to port 443 from the APIM"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    access                     = "Allow"
    priority                   = 100
    source_address_prefix      = "ApiManagement"
    source_port_range          = "*"
    destination_address_prefix = "AppService"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "Outbound-to-APIM"
    description                = "Allow egress to port 443 from the Functions Apps to APIM"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    access                     = "Allow"
    priority                   = 101
    source_address_prefix      = "AppService"
    source_port_range          = "*"
    destination_address_prefix = "ApiManagement"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "Outbound-to-Vnet"
    description                = "Allows egress on port 443 to VNET"
    direction                  = "Outbound"
    protocol                   = "Tcp"
    access                     = "Allow"
    priority                   = 102
    source_address_prefix      = "AppService"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "Inbound-web"
    description                = "Deny ingress to port 443 from the internet to Function Apps"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    access                     = "Deny"
    priority                   = 103
    source_address_prefix      = "Internet"
    source_port_range          = "*"
    destination_address_prefix = "AppService"
    destination_port_range     = "443"
  }

}

resource "azurerm_subnet_network_security_group_association" "fa_subnet_nsg_association" {
  count                     = local.is_not_dev ? 1 : 0
  network_security_group_id = azurerm_network_security_group.fa_security_group[0].id
  subnet_id                 = azurerm_subnet.fa_subnet[0].id
}