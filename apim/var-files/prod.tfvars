environment_prefix      = "prod"
location                = "UK South"
vnet_cidr               = "10.231.24.0/24"
api_management_sku_name = "Premium_1"
private_dns_zone        = ""
public_dns_zones = [
  {
    public_dns_parent_zone = "beta.bestinvest.co.uk"
    public_dns_child_zones = []
  },
  {
    public_dns_parent_zone = "account.bestinvest.co.uk"
    public_dns_child_zones = []
  }
]
public_ns_record                       = []
dns_a_records                          = {}
sg_rules                               = []
centralised_log_analytics_workspace_id = "/subscriptions/6cb0107e-b593-4d6f-bc10-7dfd0fff45c0/resourceGroups/rg-uks-prod-mgt-core/providers/Microsoft.OperationalInsights/workspaces/la-uks-prod-mgt-core"


api_backends = {
  "bestinvest-identity-api" = {
    name                       = "bestinvest-identity-api"
    url                        = "https://identityapi.bestinvest.co.uk/api/"
    validate_certificate_chain = true
  },
  "bestinvest-myaccounts-api" = {
    name                       = "bestinvest-myaccounts-api"
    url                        = "https://myaccountsapi.bestinvest.co.uk/api/"
    validate_certificate_chain = true
  },
  "bestinvest-online-api" = {
    name                       = "bestinvest-online-api"
    url                        = "https://online.bestinvest.co.uk/api/"
    validate_certificate_chain = true
  },
  "bestinvest-oisapi-api" = {
    name                       = "bestinvest-oisapi-api"
    url                        = "https://oisapi.bestinvest.co.uk/api/"
    validate_certificate_chain = true
  },
  "xplan-api" = {
    name                       = "xplan-api"
    url                        = "https://tbi.xplan.iress.co.uk/"
    validate_certificate_chain = true
  }
}

apim_routes = [
  {
    name                   = "XplanProd1"
    address_prefix         = "103.3.199.219/32"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.231.0.182"
  },
  {
    name                   = "XplanProd2"
    address_prefix         = "103.3.197.219/32"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.231.0.182"
  },
  {
    name                   = "BIProd1"
    address_prefix         = "195.99.208.187/32"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.231.0.182"
  },
  {
    name                   = "BIProd2"
    address_prefix         = "195.99.208.179/32"
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

is_zone_redundant = true
asp_capacity      = 3