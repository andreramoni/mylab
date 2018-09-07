#!/bin/bash
#Hammer:
#https://www.lisenet.com/2018/katello-create-products-repositories-content-views-lifecycle-environments-activation-keys/

. vars || ( echo "vars file not found" ; exit 1 )

#############################
echo -n "* [domain update: ${EXT_DOMAIN}] "
hammer domain update \
  --name "${EXT_DOMAIN}" \
  --organizations "${ORGANIZATION}" --locations "${LOCATION}"

echo -n "* [subnet create: ${EXT_NETWORK_NAME} - ${EXT_NETWORK_ADDRESS}] "
hammer subnet create \
  --name "${EXT_NETWORK_NAME}" \
  --network "${EXT_NETWORK_ADDRESS}" \
  --mask "${EXT_NETWORK_NETMASK}" \
  --gateway "${EXT_NETWORK_GATEWAY}" \
  --boot-mode "Static" \
  --from "${EXT_NETWORK_RANGE_FROM}" \
  --to "${EXT_NETWORK_RANGE_TO}" \
  --domains "${EXT_DOMAIN}" \
  --dns-primary "${EXT_DNS1}" \
  --ipam "Internal DB" \
  --organizations "${ORGANIZATION}" \
  --locations "${LOCATION}"

#############################
echo -n "* [domain create: ${PROV_DOMAIN}] "
hammer domain create --name "${PROV_DOMAIN}" --organizations "${ORGANIZATION}" --locations "${LOCATION}"

echo -n "* [subnet create: ${PROV_NETWORK_NAME} - ${PROV_NETWORK_ADDRESS}] "
hammer subnet create \
  --name "${PROV_NETWORK_NAME}" \
  --network "${PROV_NETWORK_ADDRESS}" \
  --mask "${PROV_NETWORK_NETMASK}" \
  --gateway "${PROV_NETWORK_GATEWAY}" \
  --boot-mode "DHCP" \
  --from "${PROV_NETWORK_RANGE_FROM}" \
  --to "${PROV_NETWORK_RANGE_TO}" \
  --domains "${PROV_DOMAIN}" \
  --ipam "DHCP" \
  --organizations "${ORGANIZATION}" \
  --locations "${LOCATION} 

#############################
echo -n "* [sync-plan create: Daily] "
hammer sync-plan create --interval 'daily' --name 'Daily' --enabled 'yes'  --organization "${ORGANIZATION}" --sync-date "`date -I`" 


#############################
echo -n "* [product create: CentOS7] "
hammer product create --name "CentOS7" --organization "${ORGANIZATION}" --sync-plan 'Daily'

echo -n "* [repository create: CentOS7|CentOS7 base] "
hammer repository create --product="CentOS7" \
  --content-type="yum" --name "CentOS7 base" \
  --url "http://mirror.centos.org/centos/7/os/x86_64" \
  --download-policy "on_demand" --organization "${ORGANIZATION}" 

echo -n "* [repository create: CentOS7|CentOS7 extras] "
hammer repository create --product="CentOS7" \
  --content-type="yum" --name "CentOS7 extras" \
  --url "http://mirror.centos.org/centos/7/extras/x86_64" \
  --download-policy "on_demand" --organization "${ORGANIZATION}"

echo -n "* [repository create: CentOS7|CentOS7 updates] "
hammer repository create --product="CentOS7" \
  --content-type="yum" --name "CentOS7 updates" \
  --url "http://mirror.centos.org/centos/7/updates/x86_64" \
  --download-policy "on_demand" --organization "${ORGANIZATION}"

echo -n "* [repository create: CentOS7|Epel 7] "
hammer repository create --product="CentOS7" \
  --content-type="yum" --name "Epel 7" \
  --url "http://download.fedoraproject.org/pub/epel/7/x86_64" \
  --download-policy "on_demand" --organization "${ORGANIZATION}"

echo -n "* [repository create: CentOS7|Katello Client ${KATELLO_VERSION}] "
hammer repository create --product="CentOS7" \
  --content-type="yum" --name "Katello Client ${KATELLO_VERSION}" \
  --url "https://fedorapeople.org/groups/katello/releases/yum/${KATELLO_VERSION}/client/el7/x86_64" \
  --download-policy "on_demand" --organization "${ORGANIZATION}"

echo -n "* [repository create: CentOS7|Puppet 4 PC1] "
hammer repository create --product="CentOS7" \
  --content-type="yum" --name "Puppet 4 PC1" \
  --url "http://yum.puppetlabs.com/el/7/PC1/x86_64" \
  --download-policy "on_demand" --organization "${KATELLO_VERSION}"

#############################
echo -n "* [repository synchronize: CentOS7 base] "
hammer repository synchronize --name "CentOS7 base" --product "CentOS7" --organization "${ORGANIZATION}" --async

echo -n "* [repository synchronize: CentOS7 extras] "
hammer repository synchronize --name "CentOS7 extras" --product "CentOS7" --organization "${ORGANIZATION}" --async

echo -n "* [repository synchronize: CentOS7 updates] "
hammer repository synchronize --name "CentOS7 updates" --product "CentOS7" --organization "${ORGANIZATION}" --async

echo -n "* [repository synchronize: Katello Client ${KATELLO_VERSION}] "
hammer repository synchronize --name "Katello Client ${KATELLO_VERSION}" --product "CentOS7" --organization "${ORGANIZATION}" --async

echo -n "* [repository synchronize: Epel 7] "
hammer repository synchronize --name "Epel 7" --product "CentOS7" --organization "${ORGANIZATION}" --async

echo -n "* [repository synchronize: Puppet 4 PC1] "
hammer repository synchronize --name "Puppet 4 PC1" --product "CentOS7" --organization "${ORGANIZATION}" --async

#############################
echo -n "* [content-view create: CentOS7] "
hammer content-view create --name "CentOS7" --organization "${ORGANIZATION}"  --product "CentOS7" --repositories "CentOS7 base,CentOS7 extras,CentOS7 updates,Epel 7,Katello Client ${KATELLO_VERSION},Puppet 4 PC1"

echo -n "* [content-view publish: CentOS7] "
hammer content-view publish --name "CentOS7" --organization "${ORGANIZATION}"

#############################
echo -n "* [activation-key create: CentOS7] "
hammer activation-key create --content-view "CentOS7" --name "CentOS7" --organization "${ORGANIZATION}"

#############################
echo -n "* [medium create: CentOS7 local] "
hammer medium create --name "CentOS local" \
  --organization "${ORGANIZATION}" \
  --os-family "Redhat" \
  --path "http://${FOREMAN_HOSTNAME}/pulp/repos/${ORGANIZATION}/Library/custom/CentOS7/CentOS7_base/" \
  --locations "${LOCATION}"

#############################
echo -n "* [os update: ID 1 media CentOS local] "
hammer os update --id 1 --media "CentOS local"


#############################
echo -n "* [global-parameter set: disable-firewall=true] "
hammer global-parameter set --name "disable-firewall" --value "true"

echo -n "* [global-parameter set: enable-puppetlabs-pc1-repo=true] "
hammer global-parameter set --name "enable-puppetlabs-pc1-repo" --value "true"

echo -n "* [global-parameter set: kt_activation_keys=CentOS7] "
hammer global-parameter set --name "kt_activation_keys" --value "CentOS7"

echo -n "* [global-parameter set: selinux-mode=disabled] "
hammer global-parameter set --name "selinux-mode" --value "disabled"

echo -n "* [global-parameter set: runinteral=600] "
hammer global-parameter set --name "runinterval" --value "600"

#############################
echo -n "* [location set-parameter: http-proxy=${PROXY}] "
hammer location set-parameter --location "Home" --name "http-proxy" --value "${PROXY}"
echo -n "* [location set-parameter: http-proxy-port=${PROXY_PORT}] "
hammer location set-parameter --location "Home" --name "http-proxy-port" --value "${PROXY_PORT}"


#############################
echo -n "* [compute-resource create: ${COMPUTE_RESOURCE_NAME}] "
hammer compute-resource create --name "${COMPUTE_RESOURCE_NAME}" \
  --organization "${ORGANIZATION}" --locations "${LOCATION}" \
  --provider "${COMPUTE_RESOURCE_PROVIDER}" \
  --server "${COMPUTE_RESOURCE_SERVER}" \
  --user "${COMPUTE_RESOURCE_USER}" \
  --password "${COMPUTE_RESOURCE_PASSWORD}" \
  --datacenter "${COMPUTE_RESOURCE_DATACENTER}" 

 
