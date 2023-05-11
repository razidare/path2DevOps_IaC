# add global resource group
resource "azurerm_resource_group" "global_rg" {
  name     = local.rg_name
  location = "West Europe"
}

# add acr
resource "azurerm_container_registry" "global_acr" {
  name                = local.acr_name
  resource_group_name = azurerm_resource_group.global_rg.name
  location            = azurerm_resource_group.global_rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

# add DNS subdomain to shikki.ro
resource "azurerm_dns_zone" "global_dns" {
  name                = local.dns_name
  resource_group_name = azurerm_resource_group.global_rg.name
}

# add DNS NS record to root DNS zone
resource "azurerm_dns_ns_record" "root_to_global" {
  name = element(split(".", local.dns_name), 0)  #barbart
  zone_name = data.azurerm_dns_zone.root.name
  resource_group_name = data.azurerm_dns_zone.root.resource_group_name
  ttl = 300

  records = azurerm_dns_zone.global_dns.name_servers
}