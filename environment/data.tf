data "azurerm_dns_zone" "global" {
  name = "barbart.shikki.ro"
  resource_group_name = "global_rg"
}

data azurerm_subscription "current" { }