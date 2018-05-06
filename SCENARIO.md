
The lab environment is behind a router that is connected to the Internet.<br>
But since it´s my own home network, we need to organize IP ranges.<br>

Let´s call my home network as the EXT Network (or Transit network).<br>

---
EXT Network (from the lab perspective)
- Network: 192.168.12.0/24 (netmask 255.255.255.0)
- Internet Gateway: 192.168.12.1
- DNS: 192.168.12.10
- Ranges convention:
  - 192.168.12.1-9:     reserved, not to be used
  - 192.168.12.10-19:   ESXi hosts 
  - 192.168.12.20-39:   VMware products
  - 192.168.12.40-59:   Core services 
  - 192.168.12.60-79:   Orquestration and config services 
  - 192.168.12.100-200: Services that needs an external IP
  - 192.168.12.201-250: My home devices using DHCP



Core services
- 192.168.12.4  - proxy.ext.lab: Squid proxy for caching
- 192.168.12.5. - pawin.ext.lab: Windows bastion host
- 192.168.12.10 - nsmaster.ext.lab: DNS server
- 192.168.12.21 - esx01.ext.lab: VMware ESX01
- 192.168.12.30 - vcenter.ext.lab: vCenter
- 192.168.12.50 - foreman.ext.lab

