#!/bin/sh
# Copyright Contributors to the Open Cluster Management project

set -e
# set -x
KUBE_VERSION=$1
UPGRADE_APPLY=$2
if [ "${UPGRADE_APPLY}" = "1" ]; then
    echo "Upgrade plan"
    echo "------------"
    kubeadm upgrade plan
    echo "Upgrade to ${KUBE_VERSION}"
    echo "--------------------------"
    kubeadm upgrade apply --yes v${KUBE_VERSION} --certificate-renewal=false
else 
    echo "Upgrade to ${KUBE_VERSION}"
    echo "--------------------------"
    kubeadm upgrade node
fi
