
The lab environment is behind a router that is connected to the Internet.<br>
But since it´s my own home network, we need to organize IP ranges.<br>

Let´s call my home network as the TRANSIT Network.<br>

---
TRANSIT Network:
- Network: 192.168.12.0/24 (netmask 255.255.255.0)
- Gateway: 192.168.12.1
- DNS: 1.1.1.1, 8.8.8.8


All of infrastructure and core services will belong to this network.

As follow:
