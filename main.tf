resource "azurerm_resource_group" "res-0" {
  location = var.location
  name     = "rsg-${local.customer_prefix}"
  tags     = local.common_tags
}






