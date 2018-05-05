The environment is behind a router that is connected to the Internet.<br>
The internal network of the router is 192.168.12.0/24 and it does outgoing NAT.<br>
The internal router IP is 192.168.12.1.<br>

This network is our EXTERNAL network to our lab environment.<br>
Our virtualization host are connected to this network.<br>
Every else networks exists only inside the virtualization hosts.<br>

---
So, we have the following setup:
EXT network:
- Network: 192.168.12.0/24 (255.255.255.0)
- Gateway: 192.168.12.1
- DNS: 192.168.12.10

Core services
