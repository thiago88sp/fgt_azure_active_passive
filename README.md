# Active/Passive High Available FortiGate pair with external and internal Azure Standard Load Balancer

More and more enterprises are turning to Microsoft Azure to extend internal data centers and take advantage of the elasticity of the public cloud. While Azure secures the infrastructure, you are responsible for protecting everything you put in it. Fortinet Security Fabric provides Azure the broad protection, native integration and automated management enabling customers with consistent enforcement and visibility across their multi-cloud infrastructure.

This Terraform template deploys a High Availability pair of FortiGate Next-Generation Firewalls accompanied by the required infrastructure. Additionally, Fortinet Fabric Connectors deliver the ability to create dynamic security policies.

# Design

In Microsoft Azure, you can deploy an active/passive pair of FortiGate VMs that communicate with each other and the Azure fabric. This FortiGate setup will receive the traffic to be inspected traffic using user defined routing (UDR) and public IPs. You can send all or specific traffic that needs inspection, going to/coming from on-prem networks or public internet by adapting the UDR routing.

This Terraform template will automatically deploy a full working environment containing the following components.

* 2 FortiGate firewall's in an active/passive deployment
* 1 external Azure Standard Load Balancer for communication with internet
* 1 internal Azure Standard Load Balancer to receive all internal traffic and forwarding towards Azure Gateways connecting ExpressRoute or Azure VPN's
* 1 VNET with 4 subnets required for the FortiGate deployment (external, internal, ha sync and ha mgmt). If using an existing vnet, it must already have 4 subnets
* 3 public IPs. The first public IP is for cluster access to/through the active FortiGate. The other two PIPs are for Management access
User Defined Routes (UDR) for the protected subnets (Validate)

![image](https://github.com/thiago88sp/fgt_azure_active_passive/assets/54182968/fed52167-7ccf-49d6-a847-3faea3118d3d)



Example of the following link: https://github.com/fortinet/azure-templates/tree/main/FortiGate/Active-Passive-ELB-ILB


## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.95.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_lb.externalLB](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb.internalLB](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.elb_backend_address_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_backend_address_pool.ilb_backend_address_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_probe.externalLB-rule-probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_probe.internalLB-rule-probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.externalLB-rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_lb_rule.externalLB-rule-2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_lb_rule.internalLB-rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_linux_virtual_machine.activefgtvm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_linux_virtual_machine.passivefgtvm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.res-1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_managed_disk.res-2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.activeport1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.activeport2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.activeport3](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.activeport4](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.passiveport1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.passiveport2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.passiveport3](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.passiveport4](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_backend_address_pool_association.backend_address_pool_association_activeport1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.backend_address_pool_association_activeport2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.backend_address_pool_association_passiveport1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.backend_address_pool_association_passiveport2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_security_group_association.activeport1nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_interface_security_group_association.activeport2nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_interface_security_group_association.activeport3nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_interface_security_group_association.activeport4nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_interface_security_group_association.passiveport1nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_interface_security_group_association.passiveport2nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_interface_security_group_association.passiveport3nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_interface_security_group_association.passiveport4nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.nsg_rule1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.nsg_rule2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.ActiveMGMTIP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.ClusterPublicIP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.PassiveMGMTIP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.res-0](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_route.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.hasyncsubnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.mgmtsubnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.privatesubnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.publicsubnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_route_table_association.internalassociate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_machine_data_disk_attachment.res-4](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.res-6](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_network.fgtvnetwork](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activeport1"></a> [activeport1](#input\_activeport1) | NIC 'untrust' private address. | `string` | `"172.18.10.4"` | no |
| <a name="input_activeport1mask"></a> [activeport1mask](#input\_activeport1mask) | NIC netmask 'untrusted'. | `string` | `"255.255.255.192"` | no |
| <a name="input_activeport2"></a> [activeport2](#input\_activeport2) | NIC 'trust' private address. | `string` | `"172.18.10.69"` | no |
| <a name="input_activeport2mask"></a> [activeport2mask](#input\_activeport2mask) | NIC netmask 'trusted'. | `string` | `"255.255.255.192"` | no |
| <a name="input_activeport3"></a> [activeport3](#input\_activeport3) | Private HA address for the NIC. | `string` | `"172.18.10.196"` | no |
| <a name="input_activeport3mask"></a> [activeport3mask](#input\_activeport3mask) | NIC netmask 'HA'. | `string` | `"255.255.255.192"` | no |
| <a name="input_activeport4"></a> [activeport4](#input\_activeport4) | Private MGMT address for the NIC. | `string` | `"172.18.10.133"` | no |
| <a name="input_activeport4mask"></a> [activeport4mask](#input\_activeport4mask) | NIC netmask 'MGMT'. | `string` | `"255.255.255.192"` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Fortigate access password | `string` | `"Passw0rd"` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Fortigate access user | `string` | `"tsp"` | no |
| <a name="input_adminsport"></a> [adminsport](#input\_adminsport) | Fortigate administration port. | `string` | `"8443"` | no |
| <a name="input_bootstrap-active"></a> [bootstrap-active](#input\_bootstrap-active) | Configuration file for the 'Active' Fortigate. | `string` | `"fgtvma-active.conf"` | no |
| <a name="input_bootstrap-passive"></a> [bootstrap-passive](#input\_bootstrap-passive) | Configuration file for the 'Passive' Fortigate. | `string` | `"fgtvmb-passive.conf"` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | n/a | `any` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | n/a | `any` | n/a | yes |
| <a name="input_customer_prefix"></a> [customer\_prefix](#input\_customer\_prefix) | Customer name prefix for resources | `string` | `"customer"` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | Specifies the size of the managed disk to create in gigabytes | `number` | `"64"` | no |
| <a name="input_hacidr"></a> [hacidr](#input\_hacidr) | HA subnet address space | `string` | `"172.18.10.192/26"` | no |
| <a name="input_license"></a> [license](#input\_license) | File where the Fortiflex license for the 'Active' Fortigate is placed. | `string` | `"license.txt"` | no |
| <a name="input_license2"></a> [license2](#input\_license2) | File where the Fortiflex license for the 'Passive' Fortigate is placed. | `string` | `"license2.txt"` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Licensing type. | `string` | `"byol"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location where resources will be placed | `string` | `"eastus"` | no |
| <a name="input_mgmtcidr"></a> [mgmtcidr](#input\_mgmtcidr) | HA subnet address space | `string` | `"172.18.10.128/26"` | no |
| <a name="input_passiveport1"></a> [passiveport1](#input\_passiveport1) | NIC 'untrust' private address. | `string` | `"172.18.10.5"` | no |
| <a name="input_passiveport1mask"></a> [passiveport1mask](#input\_passiveport1mask) | NIC netmask 'untrusted'. | `string` | `"255.255.255.192"` | no |
| <a name="input_passiveport2"></a> [passiveport2](#input\_passiveport2) | NIC 'trust' private address. | `string` | `"172.18.10.70"` | no |
| <a name="input_passiveport2mask"></a> [passiveport2mask](#input\_passiveport2mask) | NIC netmask 'trusted'. | `string` | `"255.255.255.192"` | no |
| <a name="input_passiveport3"></a> [passiveport3](#input\_passiveport3) | Private HA address for the NIC. | `string` | `"172.18.10.197"` | no |
| <a name="input_passiveport3mask"></a> [passiveport3mask](#input\_passiveport3mask) | NIC netmask 'HA'. | `string` | `"255.255.255.192"` | no |
| <a name="input_passiveport4"></a> [passiveport4](#input\_passiveport4) | Private MGMT address for the NIC. | `string` | `"172.18.10.134"` | no |
| <a name="input_passiveport4mask"></a> [passiveport4mask](#input\_passiveport4mask) | NIC netmask 'MGMT'. | `string` | `"255.255.255.192"` | no |
| <a name="input_port1gateway"></a> [port1gateway](#input\_port1gateway) | Public subnet gateway IP. | `string` | `"172.18.10.1"` | no |
| <a name="input_port2gateway"></a> [port2gateway](#input\_port2gateway) | Private subnet gateway IP. | `string` | `"172.18.10.65"` | no |
| <a name="input_port4gateway"></a> [port4gateway](#input\_port4gateway) | HA subnet gateway IP. | `string` | `"172.18.10.129"` | no |
| <a name="input_privatecidr"></a> [privatecidr](#input\_privatecidr) | Private subnet address space | `string` | `"172.18.10.64/26"` | no |
| <a name="input_publiccidr"></a> [publiccidr](#input\_publiccidr) | Public subnet address space | `string` | `"172.18.10.0/26"` | no |
| <a name="input_size"></a> [size](#input\_size) | Virtual machine SKU. | `string` | `"Standard_DS3_v2"` | no |
| <a name="input_sku_lb"></a> [sku\_lb](#input\_sku\_lb) | Load Balancer SKU | `string` | `"Standard"` | no |
| <a name="input_storage_account_type"></a> [storage\_account\_type](#input\_storage\_account\_type) | Storage type chosen for the managed disk. | `string` | `"Premium_LRS"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure configuration | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | n/a | `any` | n/a | yes |
| <a name="input_vnetcidr"></a> [vnetcidr](#input\_vnetcidr) | VNET address space | `string` | `"172.18.10.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ActiveMGMTPublicIP"></a> [ActiveMGMTPublicIP](#output\_ActiveMGMTPublicIP) | FGT-A-MGMT-PIP |
| <a name="output_FrontendIP-ELB"></a> [FrontendIP-ELB](#output\_FrontendIP-ELB) | n/a |
| <a name="output_FrontendIP-ILB"></a> [FrontendIP-ILB](#output\_FrontendIP-ILB) | n/a |
| <a name="output_PassiveMGMTPublicIP"></a> [PassiveMGMTPublicIP](#output\_PassiveMGMTPublicIP) | FGT-B-MGMT-PIP |
| <a name="output_Password"></a> [Password](#output\_Password) | n/a |
| <a name="output_ResourceGroup"></a> [ResourceGroup](#output\_ResourceGroup) | n/a |
| <a name="output_Username"></a> [Username](#output\_Username) | n/a |