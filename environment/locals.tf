locals {
    rg_name = format( "%s%s", var.environment, "_rg" ) #dev_rg
    vnet_name = "shikki"
    dns_name = format( "%s%s", var.environment, ".barbart.shikki.ro" ) # dev.barbart.shikki.ro
    pip_name = format( "%s%s", var.environment, "_pip" ) #dev_pip
    aks_name = format( "%s%s", var.environment, "_shikki_aks" ) #dev_shikki_aks
    aks_dns_prefix = "shikki"
    mysql_name = format( "%s%s", var.environment, "-shikki-mysql" ) #dev_shikki_aks
}