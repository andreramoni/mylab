#!/bin/bash
#Hammer:
#https://www.lisenet.com/2018/katello-create-products-repositories-content-views-lifecycle-environments-activation-keys/

hammer domain update --name "ext.home.lab" --organizations "RLabs" --locations "Home"

hammer subnet create \
  --name "ext.lab" \
  --network "192.168.12.0" \
  --mask "255.255.255.0" \
  --gateway "192.168.12.1" \
  --boot-mode "Static" \
  --from "192.168.12.100" \
  --to "192.168.12.149" \
  --domains "ext.home.lab" \
  --dns-primary "192.168.12.2" \
  --ipam "Internal DB" \
  --organizations "RLabs" \
  --locations "Home"

hammer domain create --name "prov.home.lab" --organizations "RLabs" --locations "Home"

hammer subnet create \
  --name "prov.home.lab" \
  --network "10.255.0.0" \
  --mask "255.255.0.0" \
  --gateway "10.255.0.1" \
  --boot-mode "DHCP" \
  --from "10.255.10.1" \
  --to "10.255.100.254" \
  --domains "prov.lab" \
  --ipam "DHCP" \
  --organizations "RLabs" \
  --locations Home


hammer sync-plan create --interval 'daily' --name 'Daily' --enabled 'yes'  --organization 'RLabs' --sync-date "`date -I`" 


hammer product create --name "CentOS7" --organization "RLabs" --sync-plan 'Daily'

hammer repository create --product="CentOS7" \
  --content-type="yum" --name "CentOS7 base" \
  --url "http://mirror.centos.org/centos/7/os/x86_64" \
  --download-policy "on_demand" --organization "RLabs" 



hammer repository create --product="CentOS7" \
  --content-type="yum" --name "CentOS7 extras" \
  --url "http://mirror.centos.org/centos/7/extras/x86_64" \
  --download-policy "on_demand" --organization "RLabs"


hammer repository create --product="CentOS7" \
  --content-type="yum" --name "CentOS7 updates" \
  --url "http://mirror.centos.org/centos/7/updates/x86_64" \
  --download-policy "on_demand" --organization "RLabs"



hammer repository create --product="CentOS7" \
  --content-type="yum" --name "Epel 7" \
  --url "http://download.fedoraproject.org/pub/epel/7/x86_64" \
  --download-policy "on_demand" --organization "RLabs"




hammer repository create --product="CentOS7" \
  --content-type="yum" --name "Katello Client 3.8" \
  --url "https://fedorapeople.org/groups/katello/releases/yum/3.8/client/el7/x86_64" \
  --download-policy "on_demand" --organization "RLabs"



hammer repository create --product="CentOS7" \
  --content-type="yum" --name "Puppet 4 PC1" \
  --url "http://yum.puppetlabs.com/el/7/PC1/x86_64" \
  --download-policy "on_demand" --organization "RLabs"





hammer repository synchronize --name "CentOS7 base" --product "CentOS7" --organization "RLabs"

hammer repository synchronize --name "CentOS7 extras" --product "CentOS7" --organization "RLabs"
hammer repository synchronize --name "CentOS7 updates" --product "CentOS7" --organization "RLabs"
hammer repository synchronize --name "Katello Client 3.8" --product "CentOS7" --organization "RLabs"
hammer repository synchronize --name "Epel 7" --product "CentOS7" --organization "RLabs"
hammer repository synchronize --name "Puppet 4 PC1" --product "CentOS7" --organization "RLabs"




hammer content-view create --name "CentOS7" --organization "RLabs"  --product "CentOS7" --product "CentOS7" --repositories "CentOS7 base,CentOS7 extras,CentOS7 updates,Epel 7,Katello Client 3.8,Puppet 4 PC1"


hammer content-view publish --name "CentOS7" --organization "RLabs"


hammer activation-key create --content-view "CentOS7" --name "CentOS7" --organization "RLabs"

hammer medium create --organization "RLabs" --os-family "Redhat" --name "CentOS local" --path "http://foreman.ext.home.lab/pulp/repos/RLabs/Library/custom/CentOS/CentOS7_base/"



hammer global-parameter set --name "disable-firewall" --value "true"
hammer global-parameter set --name "enable-puppetlabs-pc1-repo" --value "true"
hammer global-parameter set --name "http-proxy" --value "proxy.ext.lab"
hammer global-parameter set --name "http-proxy-port" --value "3128"
hammer global-parameter set --name "kt_activation_keys" --value "CentOS7"
hammer global-parameter set --name "selinux-mode" --value "disabled"
hammer global-parameter set --name "runinterval" --value "600"



 
