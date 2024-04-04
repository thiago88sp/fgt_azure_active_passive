###########################################################################################
#                                 Network Resources                                       #
###########################################################################################

// Vnets

resource "azurerm_virtual_network" "fgtvnetwork" {
  address_space       = var.address_spaces
  location            = var.location
  name                = "vnet-${local.customer_prefix}-fgt"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = local.common_tags
}

// Subnets

resource "azurerm_subnet" "publicsubnet" {
  address_prefixes     = [var.publiccidr]
  name                 = "fortinetexternalsubnet"
  resource_group_name  = azurerm_resource_group.res-0.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork.name
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_virtual_network.fgtvnetwork,
  ]
}
resource "azurerm_subnet" "hasyncsubnet" {
  address_prefixes     = [var.hacidr]
  name                 = "fortinethasyncsubnet"
  resource_group_name  = azurerm_resource_group.res-0.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork.name
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_virtual_network.fgtvnetwork,
  ]
}
resource "azurerm_subnet" "privatesubnet" {
  address_prefixes     = [var.privatecidr]
  name                 = "fortinetinternalsubnet"
  resource_group_name  = azurerm_resource_group.res-0.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork.name
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_virtual_network.fgtvnetwork,
  ]
}
resource "azurerm_subnet" "mgmtsubnet" {
  address_prefixes     = [var.mgmtcidr]
  name                 = "fortinetmanagementsubnet"
  resource_group_name  = azurerm_resource_group.res-0.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork.name
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_virtual_network.fgtvnetwork,
  ]
}

// Load Balancers

#------------------------------ ELB ----------------------------------#

resource "azurerm_lb" "externalLB" {
  location            = var.location
  name                = "FGT-${local.customer_prefix}-ExternalLoadBalancer"
  resource_group_name = azurerm_resource_group.res-0.name
  sku                 = var.sku_lb
  tags                = local.common_tags

  frontend_ip_configuration {
    name                 = "FGT-${local.customer_prefix}-ELB-FortinetExternalSubnet-FrontEnd"
    public_ip_address_id = azurerm_public_ip.ClusterPublicIP.id
  }
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}

// ELB - Backend Address Pool

resource "azurerm_lb_backend_address_pool" "elb_backend_address_pool" {
  loadbalancer_id = azurerm_lb.externalLB.id
  name            = "FGT-${local.customer_prefix}-ELB-FortinetExternalSubnet-BackEnd"
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_lb.externalLB,
  ]
}

// ELB - Probe

resource "azurerm_lb_probe" "externalLB-rule-probe" {
  loadbalancer_id = azurerm_lb.externalLB.id
  name            = "lbprobe"
  protocol        = "Http"
  request_path    = "/"
  port            = 8008
}

// ELB - Rule

resource "azurerm_lb_rule" "externalLB-rule" {
  loadbalancer_id                = azurerm_lb.externalLB.id
  name                           = "PublicLBRule-FE1-http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "FGT-${local.customer_prefix}-ELB-FortinetExternalSubnet-FrontEnd"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.elb_backend_address_pool.id]
  probe_id                       = azurerm_lb_probe.externalLB-rule-probe.id
}

resource "azurerm_lb_rule" "externalLB-rule-2" {
  loadbalancer_id                = azurerm_lb.externalLB.id
  name                           = "PublicLBRule-FE1-udp10551"
  protocol                       = "Udp"
  frontend_port                  = 10551
  backend_port                   = 10551
  frontend_ip_configuration_name = "FGT-${local.customer_prefix}-ELB-FortinetExternalSubnet-FrontEnd"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.elb_backend_address_pool.id]
  probe_id                       = azurerm_lb_probe.externalLB-rule-probe.id
}

// ELB - Association

resource "azurerm_network_interface_backend_address_pool_association" "backend_address_pool_association_activeport1" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.elb_backend_address_pool.id
  ip_configuration_name   = "ipconfig1"
  network_interface_id    = azurerm_network_interface.activeport1.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_lb_backend_address_pool.elb_backend_address_pool,
    azurerm_network_interface.activeport1,
  ]
}

resource "azurerm_network_interface_backend_address_pool_association" "backend_address_pool_association_passiveport1" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.elb_backend_address_pool.id
  ip_configuration_name   = "ipconfig1"
  network_interface_id    = azurerm_network_interface.passiveport1.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_lb_backend_address_pool.elb_backend_address_pool,
    azurerm_network_interface.passiveport1,
  ]
}

#------------------------------ ILB ----------------------------------#

resource "azurerm_lb" "internalLB" {
  location            = var.location
  name                = "FGT-${local.customer_prefix}-InternalLoadBalancer"
  resource_group_name = azurerm_resource_group.res-0.name
  sku                 = var.sku_lb
  tags                = local.common_tags

  frontend_ip_configuration {
    name      = "FGT-${local.customer_prefix}-ILB-FortinetInternalSubnet-FrontEnd"
    subnet_id = azurerm_subnet.privatesubnet.id

  }
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}

// ILB - Backend Address Pool

resource "azurerm_lb_backend_address_pool" "ilb_backend_address_pool" {
  loadbalancer_id = azurerm_lb.internalLB.id
  name            = "FGT-${local.customer_prefix}-ILB-FortinetInternalSubnet-BackEnd"
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_lb.internalLB,
  ]
}

// ILB - Probe

resource "azurerm_lb_probe" "internalLB-rule-probe" {
  loadbalancer_id = azurerm_lb.internalLB.id
  name            = "lbprobe"
  protocol        = "Http"
  request_path    = "/"
  port            = 8008
}

// ILB - Rule

resource "azurerm_lb_rule" "internalLB-rule" {
  loadbalancer_id                = azurerm_lb.internalLB.id
  name                           = "lbruleFE2all"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "FGT-${local.customer_prefix}-ILB-FortinetInternalSubnet-FrontEnd"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ilb_backend_address_pool.id]
  probe_id                       = azurerm_lb_probe.internalLB-rule-probe.id
}

// ILB - Association

resource "azurerm_network_interface_backend_address_pool_association" "backend_address_pool_association_activeport2" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.ilb_backend_address_pool.id
  ip_configuration_name   = "ipconfig1"
  network_interface_id    = azurerm_network_interface.activeport2.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_lb_backend_address_pool.ilb_backend_address_pool,
    azurerm_network_interface.activeport2,
  ]
}

resource "azurerm_network_interface_backend_address_pool_association" "backend_address_pool_association_passiveport2" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.ilb_backend_address_pool.id
  ip_configuration_name   = "ipconfig1"
  network_interface_id    = azurerm_network_interface.passiveport2.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_lb_backend_address_pool.ilb_backend_address_pool,
    azurerm_network_interface.passiveport2,
  ]
}

#------------------------------ Network Interfaces ----------------------------------#

// VM Active

resource "azurerm_network_interface" "activeport1" {
  enable_accelerated_networking = true
  enable_ip_forwarding          = true
  location                      = var.location
  name                          = "FGT-${local.customer_prefix}01-Nic1"
  resource_group_name           = azurerm_resource_group.res-0.name
  tags                          = local.common_tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.publicsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport1

  }
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_subnet.publicsubnet,
  ]
}

resource "azurerm_network_interface" "activeport2" {
  enable_accelerated_networking = true
  enable_ip_forwarding          = true
  location                      = var.location
  name                          = "FGT-${local.customer_prefix}01-Nic2"
  resource_group_name           = azurerm_resource_group.res-0.name
  tags                          = local.common_tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.privatesubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport2
  }
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_subnet.privatesubnet,
  ]
}

resource "azurerm_network_interface" "activeport3" {
  enable_accelerated_networking = true
  enable_ip_forwarding          = true
  location                      = var.location
  name                          = "FGT-${local.customer_prefix}01-Nic3"
  resource_group_name           = azurerm_resource_group.res-0.name
  tags                          = local.common_tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.hasyncsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport3 # Using non-routable IP for HA-Sync. (https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-faq#what-address-ranges-can-i-use-in-my-virtual-networks)

  }
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_subnet.hasyncsubnet,
  ]
}

resource "azurerm_network_interface" "activeport4" {
  enable_accelerated_networking = true
  enable_ip_forwarding          = true
  location                      = var.location
  name                          = "FGT-${local.customer_prefix}01-Nic4"
  resource_group_name           = azurerm_resource_group.res-0.name
  tags                          = local.common_tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.mgmtsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport4
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.ActiveMGMTIP.id

  }
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_public_ip.ActiveMGMTIP,
    azurerm_subnet.mgmtsubnet,
  ]
}

// VM Passive

resource "azurerm_network_interface" "passiveport1" {
  enable_accelerated_networking = true
  enable_ip_forwarding          = true
  location                      = var.location
  name                          = "FGT-${local.customer_prefix}02-Nic1"
  resource_group_name           = azurerm_resource_group.res-0.name
  tags                          = local.common_tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.publicsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.passiveport1

  }
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_subnet.publicsubnet,
  ]
}

resource "azurerm_network_interface" "passiveport2" {
  enable_accelerated_networking = true
  enable_ip_forwarding          = true
  location                      = var.location
  name                          = "FGT-${local.customer_prefix}02-Nic2"
  resource_group_name           = azurerm_resource_group.res-0.name
  tags                          = local.common_tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.privatesubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.passiveport2


  }
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_subnet.privatesubnet,
  ]
}

resource "azurerm_network_interface" "passiveport3" {
  enable_accelerated_networking = true
  enable_ip_forwarding          = true
  location                      = var.location
  name                          = "FGT-${local.customer_prefix}02-Nic3"
  resource_group_name           = azurerm_resource_group.res-0.name
  tags                          = local.common_tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.hasyncsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.passiveport3

  }
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_subnet.hasyncsubnet,
  ]
}

resource "azurerm_network_interface" "passiveport4" {
  enable_accelerated_networking = true
  enable_ip_forwarding          = true
  location                      = var.location
  name                          = "FGT-${local.customer_prefix}02-Nic4"
  resource_group_name           = azurerm_resource_group.res-0.name
  tags                          = local.common_tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.mgmtsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.passiveport4
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.PassiveMGMTIP.id

  }
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_public_ip.PassiveMGMTIP,
    azurerm_subnet.mgmtsubnet,
  ]
}

// NSG

resource "azurerm_network_security_group" "nsg" {
  location            = var.location
  name                = "FGT-${local.customer_prefix}-NSG"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = local.common_tags
}

#------------------------------ Rule1 ----------------------------------#
resource "azurerm_network_security_rule" "nsg_rule1" {
  access                      = "Allow"
  description                 = "Allow all in"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "AllowAllInbound"
  network_security_group_name = "FGT-${local.customer_prefix}-NSG"
  priority                    = 100
  protocol                    = "*"
  resource_group_name         = azurerm_resource_group.res-0.name
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_security_group.nsg,
  ]
}
#------------------------------ Rule2 ----------------------------------#
resource "azurerm_network_security_rule" "nsg_rule2" {
  access                      = "Allow"
  description                 = "Allow all out"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Outbound"
  name                        = "AllowAllOutbound"
  network_security_group_name = "FGT-${local.customer_prefix}-NSG"
  priority                    = 105
  protocol                    = "*"
  resource_group_name         = azurerm_resource_group.res-0.name
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_security_group.nsg,
  ]
}

#------------------------------ Association ----------------------------------#

//Association Active Port 1//

resource "azurerm_network_interface_security_group_association" "activeport1nsg" {
  network_interface_id      = azurerm_network_interface.activeport1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.activeport1,
    azurerm_network_security_group.nsg,
  ]
}

//Association Active Port 2//

resource "azurerm_network_interface_security_group_association" "activeport2nsg" {
  network_interface_id      = azurerm_network_interface.activeport2.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.activeport2,
    azurerm_network_security_group.nsg,
  ]
}

//Association Active Port 3//

resource "azurerm_network_interface_security_group_association" "activeport3nsg" {
  network_interface_id      = azurerm_network_interface.activeport3.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.activeport3,
    azurerm_network_security_group.nsg,
  ]
}

//Association Active Port 4//

resource "azurerm_network_interface_security_group_association" "activeport4nsg" {
  network_interface_id      = azurerm_network_interface.activeport4.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.activeport4,
    azurerm_network_security_group.nsg,
  ]
}

//Association Passive Port 1//

resource "azurerm_network_interface_security_group_association" "passiveport1nsg" {
  network_interface_id      = azurerm_network_interface.passiveport1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.passiveport1,
    azurerm_network_security_group.nsg,
  ]
}

//Association Passive Port 2//

resource "azurerm_network_interface_security_group_association" "passiveport2nsg" {
  network_interface_id      = azurerm_network_interface.passiveport2.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.passiveport2,
    azurerm_network_security_group.nsg,
  ]
}

//Association Passive Port 3//

resource "azurerm_network_interface_security_group_association" "passiveport3nsg" {
  network_interface_id      = azurerm_network_interface.passiveport3.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.passiveport3,
    azurerm_network_security_group.nsg,
  ]
}

//Association Passive Port 4//

resource "azurerm_network_interface_security_group_association" "passiveport4nsg" {
  network_interface_id      = azurerm_network_interface.passiveport4.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.passiveport4,
    azurerm_network_security_group.nsg,
  ]
}


// PublicIP

#------------------------------ Active MGMT Public IP ----------------------------------#


resource "azurerm_public_ip" "ActiveMGMTIP" {
  allocation_method   = "Static"
  location            = var.location
  name                = "FGT-${local.customer_prefix}-FGT-A-MGMT-PIP"
  resource_group_name = azurerm_resource_group.res-0.name
  sku                 = "Standard"
  tags                = local.common_tags

  zones = ["1", "2", "3"]
}

#------------------------------ Passive MGMT Public IP ----------------------------------#

resource "azurerm_public_ip" "PassiveMGMTIP" {
  allocation_method   = "Static"
  location            = var.location
  name                = "FGT-${local.customer_prefix}-FGT-B-MGMT-PIP"
  resource_group_name = azurerm_resource_group.res-0.name
  sku                 = "Standard"
  tags                = local.common_tags

  zones = ["1", "2", "3"]
}

#------------------------------ Cluster Public IP ----------------------------------#

resource "azurerm_public_ip" "ClusterPublicIP" {
  allocation_method   = "Static"
  domain_name_label   = "fgt-${local.customer_prefix}"
  location            = var.location
  name                = "FGT-${local.customer_prefix}-FGT-PIP"
  resource_group_name = azurerm_resource_group.res-0.name
  sku                 = "Standard"
  tags                = local.common_tags

  zones = ["1", "2", "3"]
}



