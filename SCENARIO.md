
The lab environment is behind a router that is connected to the Internet.<br>
But since it´s my own home network, we need to organize IP ranges.<br>

Let´s call my(internal)  home network as the EXTERNAL LAB Network.<br>

---
EXTERNAL Network:
- Network: 192.168.12.0/24 (netmask 255.255.255.0)
- Gateway: 192.168.12.1 (my router)
- DNS: 1.1.1.1 and 8.8.4.4 (but the lab won't use that)



We'll segment this external network as follow:

- 192.168.12.2-29: Basic services like DNS, Jumpboxes etc 
- 192.168.12.29-39: VMware stuff (esxi hosts, vcenter, vrealize etc)
- 192.168.12.40-59: RLabs-prod Core services that needs to exists before the lab firewall (Foreman, DNS, Proxy, Jumpboxes)
- 192.168.12.60-99: RLabs-prod firewall and nat addresses
- 192.168.12.100-129: Misc tests that should use the external network (ip allocation managed by foreman)
- 192.168.12.130-139: RLabs-dev. Katello-nightly and provisioning tests
- 192.168.12.140-199: Free
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
- 10.255.0.0/16: prov.lab - Provisioning

The firewalls will use last octect as 2 and 3, and 1 for the VIP on each network.
