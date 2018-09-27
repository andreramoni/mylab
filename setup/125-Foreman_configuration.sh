#!/bin/bash

. vars || ( echo "vars file not found" ; exit 1 )


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
#echo -n "* [location set-parameter: http-proxy=${PROXY}] "
#hammer location set-parameter --location "${LOCATION}" --name "http-proxy" --value "${PROXY}"
#echo -n "* [location set-parameter: http-proxy-port=${PROXY_PORT}] "
#hammer location set-parameter --location "${LOCATION}" --name "http-proxy-port" --value "${PROXY_PORT}"


#############################
echo -n "* [compute-resource create: ${COMPUTE_RESOURCE_NAME}] "
hammer compute-resource create --name "${COMPUTE_RESOURCE_NAME}" \
  --organization "${ORGANIZATION}" --locations "${LOCATION}" \
  --provider "${COMPUTE_RESOURCE_PROVIDER}" \
  --server "${COMPUTE_RESOURCE_SERVER}" \
  --user "${COMPUTE_RESOURCE_USER}" \
  --password "${COMPUTE_RESOURCE_PASSWORD}" \
  --datacenter "${COMPUTE_RESOURCE_DATACENTER}" 

 
