
The environment is behind a router that is connected to the Internet.<br>
The internal network of the router is 192.168.12.0/24 and it does outgoing NAT.<br>
The internal router IP is 192.168.12.1.<br>

Since THIS IS my home network, we need to organize IP ranges, put core services on it and call it the EXTERNAL NETWORK.

Critical services run on this network, and there are firewalls that routes traffic to internal networks inside the lab.

So, below are the conventions for this network.

-----
EXT network (that is my home network used by my devices):
- Network: 192.168.12.0/24 (255.255.255.0)
- Internet Gateway: 192.168.12.1
- DNS: 1.1.1.1
- IP range convention:
  - 192.168.12.201-250: DHCP managed by my lan/wifi access point
  - 192.168.12.:

Core services
- 192.168.12.4  - proxy.ext.lab: Squid proxy for caching
- 192.168.12.5. - pawin.ext.lab: Windows bastion host
- 192.168.12.10 - nsmaster.ext.lab: DNS server
- 192.168.12.21 - esx01.ext.lab: VMware ESX01
- 192.168.12.30 - vcenter.ext.lab: vCenter
- 192.168.12.50 - foreman.ext.lab

