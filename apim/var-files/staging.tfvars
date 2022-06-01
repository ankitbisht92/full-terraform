environment_prefix      = "staging"
location                = "UK South"
vnet_cidr               = "10.233.25.0/24"
api_management_sku_name = "Developer_1"
private_dns_zone        = "uat3.bestinvest.co.uk"
public_dns_zones = [
  {
    public_dns_parent_zone = "bi-digital.co.uk"
    public_dns_child_zones = ["dev", "alpha", "account"]
  }
]
public_ns_record = [
  {
    public_dns_zone       = "bi-digital.co.uk"
    public_ns_record_name = "webalpha"
    public_ns_name_server = [
      "ns1-09.azure-dns.com.",
      "ns2-09.azure-dns.net.",
      "ns3-09.azure-dns.org.",
      "ns4-09.azure-dns.info."
    ]
  }
]
centralised_log_analytics_workspace_id = "/subscriptions/6cb0107e-b593-4d6f-bc10-7dfd0fff45c0/resourceGroups/rg-uks-prod-mgt-core/providers/Microsoft.OperationalInsights/workspaces/la-uks-prod-mgt-core"

dns_a_records = {
  "online" = {
    name    = "online"
    records = ["10.1.63.5"]

  },
  "myaccountsapi" = {
    name    = "myaccountsapi"
    records = ["10.1.63.5"]

  },
  "identityapi" = {
    name    = "identityapi"
    records = ["10.1.63.5"]

  },

  "oisapi" = {
    name    = "oisapi"
    records = ["10.1.63.5"]

  }
}

sg_rules = [
  //ToDo: rule 104 can be removed after the Azure migration
  {
    name                       = "Outbound-To-MyAccounts"
    description                = "Allows egress to MyAccounts"
    priority                   = 104
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "10.233.25.0/24" # same as vnet_cidr
    source_port_range          = "*"
    destination_address_prefix = "10.1.63.5/32"
    destination_port_range     = 443
  },
  {
    name                       = "Outbound-To-XplanUAT2"
    description                = "Allows egress to Xplan UAT2"
    priority                   = 105
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "10.233.25.0/24" # same as vnet_cidr
    source_port_range          = "*"
    destination_address_prefix = "103.3.199.215/32"
    destination_port_range     = 443
  },
    {
    name                       = "Outbound-To-AzureDemo2"
    description                = "Allows egress to Azure BI Demo2"
    priority                   = 106
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "10.233.25.0/24" # same as vnet_cidr
    source_port_range          = "*"
    destination_address_prefix = "20.108.140.237/32"
    destination_port_range     = 443
}]


api_backends = {
  "bestinvest-identity-api" = {
    name                       = "bestinvest-identity-api"
    url                        = "https://identityapi.demo2.bestinvest.co.uk/api/"
    validate_certificate_chain = true
  },
  "bestinvest-myaccounts-api" = {
    name                       = "bestinvest-myaccounts-api"
    url                        = "https://myaccountsapi.demo2.bestinvest.co.uk/api/"
    validate_certificate_chain = true
  },
  "bestinvest-online-api" = {
    name                       = "bestinvest-online-api"
    url                        = "https://online.demo2.bestinvest.co.uk/api/"
    validate_certificate_chain = true
  },
  "bestinvest-oisapi-api" = {
    name                       = "bestinvest-oisapi-api"
    url                        = "https://oisapi.demo2.bestinvest.co.uk/api/"
    validate_certificate_chain = true
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
  {   //ToDo: remove after the Azure migration
    name                   = "BIDemo2"
    address_prefix         = "194.75.193.36/32"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.231.0.182"
  },
  {
    name                   = "PrivateIPRanges"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.231.0.182"
  },
  {
    name                   = "AzureBIDemo2"
    address_prefix         = "20.108.140.237/32"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.231.0.182"
  }
]

is_zone_redundant = true
asp_capacity      = 3
//added to test function apps issue DH-3948