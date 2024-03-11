output "ResourceGroup" {
  value = azurerm_resource_group.res-0.name
}

output "ActiveMGMTPublicIP" {
  value       = format("https://%s:%s", azurerm_public_ip.ActiveMGMTIP.ip_address, var.adminsport)
  description = "FGT-A-MGMT-PIP"
}

output "PassiveMGMTPublicIP" {
  value       = format("https://%s:%s", azurerm_public_ip.PassiveMGMTIP.ip_address, var.adminsport)
  description = "FGT-B-MGMT-PIP"
}

output "FrontendIP-ELB" {
  value = azurerm_public_ip.ClusterPublicIP.ip_address

}

output "FrontendIP-ILB" {
  value = azurerm_lb.internalLB.private_ip_address

}

output "Username" {
  value = var.admin_username
}

output "Password" {
  value = var.admin_password
}
