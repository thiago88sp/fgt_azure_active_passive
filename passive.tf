resource "azurerm_linux_virtual_machine" "passivefgtvm" {
  admin_password                  = var.admin_password
  admin_username                  = var.admin_username
  disable_password_authentication = false
  location                        = var.location
  name                            = "FGT-Customer02"
  network_interface_ids = [
    azurerm_network_interface.passiveport1.id,
    azurerm_network_interface.passiveport2.id,
    azurerm_network_interface.passiveport3.id,
    azurerm_network_interface.passiveport4.id
  ]

  resource_group_name = azurerm_resource_group.res-0.name
  size                = var.size
  tags = {
    provider = "6EB3B02F-50E5-4A3E-8CB8-2E12925831AP"
  }
  zone = "2"
  boot_diagnostics {}

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
    version   = "7.0.11"
  }

  custom_data = base64encode(templatefile("${var.bootstrap-passive}", {
    type            = var.license_type,
    license_file    = var.license2,
    port1_ip        = var.passiveport1,
    port1_mask      = var.passiveport1mask,
    port2_ip        = var.passiveport2,
    port2_mask      = var.passiveport2mask,
    port3_ip        = var.passiveport3,
    port3_mask      = var.passiveport3mask,
    port4_ip        = var.passiveport4,
    port4_mask      = var.passiveport4mask,
    active_peerip   = var.activeport3,
    mgmt_gateway_ip = var.port1gateway,
    defaultgwy      = var.port2gateway,
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
    azurerm_network_interface.passiveport1,
    azurerm_network_interface.passiveport2,
    azurerm_network_interface.passiveport3,
    azurerm_network_interface.passiveport4,
  ]
}


resource "azurerm_virtual_machine_data_disk_attachment" "res-6" {
  caching            = "None"
  #create_option      = "Empty"
  lun                = 0
  managed_disk_id    = azurerm_managed_disk.res-2.id
  virtual_machine_id = azurerm_linux_virtual_machine.passivefgtvm.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_managed_disk.res-2,
    azurerm_linux_virtual_machine.passivefgtvm,
  ]
}

resource "azurerm_managed_disk" "res-2" {
  create_option        = "Empty"
  location             = var.location
  name                 = "FGT-Customer02_disk2_7e0a588d60eb45b1b495daf3cbdd6f4a"
  resource_group_name  = azurerm_resource_group.res-0.name
  storage_account_type = "Premium_LRS"
  disk_size_gb         = var.disk_size_gb

  tags = {
    provider = "6EB3B02F-50E5-4A3E-8CB8-2E12925831AP"
  }
  zone = "2"
  depends_on = [ azurerm_resource_group.res-0 ]
}