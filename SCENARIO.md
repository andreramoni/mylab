
The lab environment is behind a router that is connected to the Internet.<br>
But since it´s my own home network, we need to organize IP ranges.<br>

Let´s call my home network as the TRANSITos EXTERNAL Network.<br>

---
EXTERNAL/TRANSIT Network:
- Network: 192.168.12.0/24 (netmask 255.255.255.0)
- Gateway: 192.168.12.1
- DNS: 192.168.12.2


We´ll use this external network as follow:

- 192.168.12.2-19: Basic services, DNS, Jumpboxes etc 
- 192.168.12.20-29: ESXi hosts
- 192.168.12.30-49: VMware appliances
- 192.168.12.50-69: Orquestration hosts
- 192.168.12.100-149: Foreman provisioning
- 192.168.12.150-199: Katello provisioning
- 192.168.12.200-254: DHCP range used by my home devices


LAB core services:
- 192.168.12.2: nsmaster.ext.lab
- 192.168.12.5: pawin.ext.lab
- 192.168.12.9: proxy.ext.lab
- 192.168.12.10: fw.ext.lab
- 192.168.12.11: fw01.ext.lab
- 192.168.12.12: fw02.ext.lab
- 192.168.12.21: esx01.ext.lab
- 192.168.12.30: vcenter.ext.lab
- 192.168.12.50: foreman.ext.lab

Internal networks:
- 10.255.0.0/16: mgmt.lab - Management and provisioning
- 10.0.0.0/16: srv.lab - Internal services
- 10.1.0.0/16: dmz1.lab - First DMZ network  (outside connections)
- 10.2.0.0/16: dmz2.lab - Second DMZ network (inside scope)

The firewalls will use last octect as 2 and 3, and 1 for the VIP on each network.
