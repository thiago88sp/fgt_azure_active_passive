output "ResourceGroup" {
  value = azurerm_resource_group.res-0.name
}

output "ActiveMGMTPublicIP" {
  value       = format("https://%s:%s", azurerm_public_ip.ActiveMGMTIP.ip_address, var.adminsport)
  description = "Access to management console on 'Active' Fortigate."
}

output "PassiveMGMTPublicIP" {
  value       = format("https://%s:%s", azurerm_public_ip.PassiveMGMTIP.ip_address, var.adminsport)
  description = "Access to management console on 'Passive' Fortigate."
}

output "FrontendIP-ELB" {
  value = azurerm_public_ip.ClusterPublicIP.ip_address
  description = "External Load Balancer public IP."

}

output "FrontendIP-ILB" {
  value = azurerm_lb.internalLB.private_ip_address
  description = "Internal Load Balancer private IP."

}

output "Username" {
  value = var.admin_username
  description = "Fortigate access user"
}

output "Password" {
  value = var.admin_password
  description = "Fortigate access password"
}
