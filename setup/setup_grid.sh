#!/bin/bash 
source /grid/fermiapp/products/common/etc/setups.sh
setup jobsub_client
kinit asmith
kx509
voms-proxy-init -noregen -rfc -voms fermilab:/fermilab/uboone/Role=Analysis
