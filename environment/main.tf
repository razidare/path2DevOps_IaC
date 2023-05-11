# add env resource group
resource "azurerm_resource_group" "env_rg" {
  name     = local.rg_name
  location = "West Europe"
}

# add Vnet
resource "azurerm_virtual_network" "env_vnet" {
  name                = local.vnet_name
  location            = azurerm_resource_group.env_rg.location
  resource_group_name = azurerm_resource_group.env_rg.name
  address_space       = ["10.0.0.0/27"]

  subnet {
    name           = "aks_subnet"
    address_prefix = "10.0.0.0/28"
  }
}

# add DNS subdomain to barbart.shikki.ro
resource "azurerm_dns_zone" "env_dns" {
  name                = local.dns_name
  resource_group_name = azurerm_resource_group.env_rg.name
}

# add DNS NS record to root DNS zone
resource "azurerm_dns_ns_record" "global_to_env" {
  name = element(split(".", local.dns_name), 0)  #dev
  zone_name = data.azurerm_dns_zone.global.name
  resource_group_name = data.azurerm_dns_zone.global.resource_group_name
  ttl = 300

  records = azurerm_dns_zone.env_dns.name_servers
}

# aks
resource "azurerm_kubernetes_cluster" "env_aks" {
  name                = local.aks_name
  location            = azurerm_resource_group.env_rg.location
  resource_group_name = azurerm_resource_group.env_rg.name
  dns_prefix          = local.aks_dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

# pip
resource "azurerm_public_ip" "example" {
  name                = local.pip_name
  location            = azurerm_resource_group.env_rg.location
  resource_group_name = azurerm_resource_group.env_rg.name
  allocation_method   = "Static"
}

# mysql server/db
resource "azurerm_mysql_server" "env_mysql_srv" {
  name                = local.mysql_name
  location            = azurerm_resource_group.env_rg.location
  resource_group_name = azurerm_resource_group.env_rg.name

  administrator_login          = "mysqladmin01"
  administrator_login_password = "T3rraformP@ss"

  sku_name   = "B_Gen5_1"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "example" {
  name                = "db1"
  resource_group_name = azurerm_resource_group.env_rg.name
  server_name         = azurerm_mysql_server.env_mysql_srv.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}