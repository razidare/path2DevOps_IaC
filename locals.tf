locals {
    rg_name = format( "%s%s", var.environment, "_rg" ) #global_rg
    acr_name = "shikki"
    dns_name = "barbart.shikki.ro"
}