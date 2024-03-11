resource "azurerm_resource_group" "res-0" {
  location = var.location
  name     = var.resource_group_name
  tags = {
    Source = "terraform"
  }
}






