data "azurerm_dns_zone" "root" {
  name = "shikki.ro"
  resource_group_name = "moved-resources"
}