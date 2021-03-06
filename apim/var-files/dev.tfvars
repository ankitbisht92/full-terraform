environment_prefix                     = "dev"
location                               = "UK South"
vnet_cidr                              = "10.233.24.0/24"
api_management_sku_name                = "Developer_1"
private_dns_zone                       = "test3.bestinvest.co.uk"
public_dns_zones                       = []
public_ns_record                       = []
centralised_log_analytics_workspace_id = "/subscriptions/6cb0107e-b593-4d6f-bc10-7dfd0fff45c0/resourceGroups/rg-uks-prod-mgt-core/providers/Microsoft.OperationalInsights/workspaces/la-uks-prod-mgt-core"

dns_a_records = {
  "online" = {
    name    = "online"
    records = ["10.233.64.99"]

  },
  "myaccountsapi" = {
    name    = "myaccountsapi"
    records = ["10.233.64.99"]

  },
  "identityapi" = {
    name    = "identityapi"
    records = ["10.233.64.99"]

  },

  "oisapi" = {
    name    = "oisapi"
    records = ["10.233.64.99"]

  }
}

sg_rules = [
  {
    name                       = "Outbound-To-XplanUAT2"
    description                = "Allows egress to Xplan UAT2"
    priority                   = 104
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "10.233.24.0/24" # same as vnet_cidr
    source_port_range          = "*"
    destination_address_prefix = "103.3.199.215/32"
    destination_port_range     = 443
  },
  {
    name                       = "Outbound-To-BITest3-Azure"
    description                = "Allows egress to BI Test3 instance in Azure"
    priority                   = 105
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "10.233.24.0/24" # same as vnet_cidr
    source_port_range          = "*"
    destination_address_prefix = "10.233.64.99/32"
    destination_port_range     = 443
}]

api_backends = {
  "bestinvest-identity-api" = {
    name                       = "bestinvest-identity-api"
    url                        = "https://identityapi.test3.bestinvest.co.uk/api/"
    validate_certificate_chain = false
  },
  "bestinvest-myaccounts-api" = {
    name                       = "bestinvest-myaccounts-api"
    url                        = "https://myaccountsapi.test3.bestinvest.co.uk/api/"
    validate_certificate_chain = false
  },
  "bestinvest-online-api" = {
    name                       = "bestinvest-online-api"
    url                        = "https://online.test3.bestinvest.co.uk/api/"
    validate_certificate_chain = false
  },
  "bestinvest-oisapi-api" = {
    name                       = "bestinvest-oisapi-api"
    url                        = "https://oisapi.test3.bestinvest.co.uk/api/"
    validate_certificate_chain = false
  },
  "xplan-api" = {
    name                       = "xplan-api"
    url                        = "https://tbigroupuat2.xplan.iress.co.uk/"
    validate_certificate_chain = true
  }
}

apim_routes = [
  {
    name                   = "XplanUAT2"
    address_prefix         = "103.3.199.215/32"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.231.0.182"
  },
  {
    name                   = "PrivateIPRanges"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.231.0.182"
  }
]