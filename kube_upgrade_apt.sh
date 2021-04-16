#!/bin/sh
# Copyright Contributors to the Open Cluster Management project

set -e
# set -x
KUBE_VERSION=$1
LIST_VERSIONS=$2

#from https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl
set +e
apt-get update
if [ $? != 0 ]; then
    sed -i.bak -r "s|archive.ubuntu.com|old-releases.ubuntu.com|" /etc/apt/sources.list
    sed -i.bak -r "s|security.ubuntu.com|old-releases.ubuntu.com|" /etc/apt/sources.list
    set -e
    apt-get update
fi

# apt-get install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

# from https://v1-17.docs.kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/

apt-get update

#find the list of available kubeadm
echo "Available versions:"
echo "-------------------"
apt-cache madison kubeadm
if [ "${LIST_VERSIONS}" = "1" ]
then
   exit 0
fi
echo "------------------------------------------------"
apt-cache madison kubeadm | grep ${KUBE_VERSION}-00

echo "Install kubectl, kubeadm, kubelet: ${KUBE_VERSION}"
echo "---------------------------------"

apt-get update 
apt-get install -y --allow-change-held-packages  --allow-downgrades -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" kubeadm=${KUBE_VERSION}-00 kubelet=${KUBE_VERSION}-00 kubectl=${KUBE_VERSION}-00


