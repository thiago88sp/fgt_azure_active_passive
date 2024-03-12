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
