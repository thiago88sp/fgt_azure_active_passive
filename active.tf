resource "azurerm_linux_virtual_machine" "activefgtvm" {
  admin_password                  = var.admin_password
  admin_username                  = var.admin_username
  disable_password_authentication = false
  location                        = var.location
  name                            = "FGT-Customer01"
  network_interface_ids = [
    azurerm_network_interface.activeport1.id,
    azurerm_network_interface.activeport2.id,
    azurerm_network_interface.activeport3.id,
    azurerm_network_interface.activeport4.id
  ]
  resource_group_name = azurerm_resource_group.res-0.name
  size                = var.size
  tags = {
    Source = "terraform"
  }
  zone = "1"
  boot_diagnostics {
  }
  identity {
    type = "SystemAssigned"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  plan {
    name      = "fortinet_fg-vm"
    product   = "fortinet_fortigate-vm_v5"
    publisher = "fortinet"
  }
  source_image_reference {
    offer     = "fortinet_fortigate-vm_v5"
    publisher = "fortinet"
    sku       = "fortinet_fg-vm"
    version   = "7.4.3"
  }

  custom_data = base64encode(templatefile("${var.bootstrap-active}", {
    type            = var.license_type,
    license_file    = var.license,
    port1_ip        = var.activeport1,
    port1_mask      = var.activeport1mask,
    port2_ip        = var.activeport2,
    port2_mask      = var.activeport2mask,
    port3_ip        = var.activeport3,
    port3_mask      = var.activeport3mask,
    port4_ip        = var.activeport4,
    port4_mask      = var.activeport4mask,
    passive_peerip  = var.passiveport3,
    mgmt_gateway_ip = var.port4gateway,
    defaultgwy      = var.port1gateway,
    tenant          = var.tenant_id,
    subscription    = var.subscription_id,
    clientid        = var.client_id,
    clientsecret    = var.client_secret,
    adminsport      = var.adminsport,
    rsg             = azurerm_resource_group.res-0.name,
    clusterip       = azurerm_public_ip.ClusterPublicIP.name,
    routename       = azurerm_route_table.internal.name
  }))

  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.activeport1,
    azurerm_network_interface.activeport2,
    azurerm_network_interface.activeport3,
    azurerm_network_interface.activeport4,
  ]
}

resource "azurerm_managed_disk" "res-1" {
  create_option        = "Empty"
  location             = var.location
  name                 = "FGT-Customer01_disk2_f066a9849e0740d5a82f3d266f56fbca"
  resource_group_name  = azurerm_resource_group.res-0.name
  storage_account_type = "Premium_LRS"
  disk_size_gb         = var.disk_size_gb

  tags = {
    Source = "terraform"
  }
  zone = "1"
  depends_on = [ azurerm_resource_group.res-0 ]
}

resource "azurerm_virtual_machine_data_disk_attachment" "res-4" {
  caching            = "None"
  #create_option      = "Empty"
  lun                = 0
  managed_disk_id    = azurerm_managed_disk.res-1.id
  virtual_machine_id = azurerm_linux_virtual_machine.activefgtvm.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_managed_disk.res-1,
    azurerm_linux_virtual_machine.activefgtvm,
  ]
}