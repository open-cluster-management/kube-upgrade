[comment]: # ( Copyright Contributors to the Open Cluster Management project )
# Kube upgrade

This project contains scripts to upgrade a cluster from one kube version to another.
Check the [notes](#notes) for upgrade between 1.6.z to 1.7.z.

## Requirements

1) Each node must have access to internet.
2) docker
3) kubectl

## Usage

1. Login to your cluster.
2. Get the list of available version: `./kube_upgrade.sh -l`
3. Run `./kube_upgrade.sh -u <desired_version>` 

## Kubernetes distro 

These scripts were tested on the following kubernetes distribution:

- [KinD](https://kind.sigs.k8s.io/) 

### KinD

### Other distribution

Other distribution could be integrated by creating similar script than [kube_upgrade_apt.sh](./kube_upgrade_apt.sh) in order to install the new package kubeadm, kubelet and kubectl.

## Notes

### Upgrade from 1.6.z to 1.7.z

Due to an incompatibility between the kubelet and the apiServer when upgrading from 1.6.z to 1.7.z [kubernetes issue 86094](https://github.com/kubernetes/kubernetes/issues/86094), the following lines must be added to the file /var/lib/kubelet/config.yaml in each node.

```yaml
featureGates:
   CSIMigration: false
```
