
#!/bin/bash
# Copyright Contributors to the Open Cluster Management project

set -e
# set -x
upgrade() {
  CONTAINER_NAME=$1
  TARGET_VERSION=$2
  UPGRADE_APPLY=$3
  LIST_VERSIONS=$4
  echo "----------------------------------------------------------------"
  echo "Upgrade container ${CONTAINER_NAME} with version ${TARGET_VERSION}"
  echo "----------------------------------------------------------------"
  docker cp kube_upgrade_apt.sh ${CONTAINER_NAME}:/
  docker cp kube_upgrade_kubeadm.sh ${CONTAINER_NAME}:/
  docker exec ${CONTAINER_NAME} /bin/sh /kube_upgrade_apt.sh ${TARGET_VERSION} ${LIST_VERSIONS}
  docker exec ${CONTAINER_NAME} /bin/sh -c "rm /kube_upgrade_apt.sh"
  if [ "${LIST_VERSIONS}" == "1" ]
  then
    exit 0
  fi

  echo "Sleep 20 sec"
  sleep 20

  kubectl get node 
  while kubectl get node | grep NotReady ;
  do
    sleep 1
    echo "Wait node ready..."
  done

  docker exec ${CONTAINER_NAME} /bin/sh /kube_upgrade_kubeadm.sh ${TARGET_VERSION} ${UPGRADE_APPLY}
  docker exec ${CONTAINER_NAME} /bin/sh -c "rm /kube_upgrade_kubeadm.sh"

  # echo "Installed version:"
  # kubectl version
}

while getopts u:lh flag
do 
  case "${flag}" in
    u) TARGET_VERSION="${OPTARG}";;
    l) LIST_VERSIONS="1";;
    h) HELP="help";;
    [?]) HELP="help"
  esac
done
if [ "$LIST_VERSIONS" == "1" ]
then
  TARGET_VERSION="LIST"
fi
if [ -z "$TARGET_VERSION" ]
then
  HELP="help"
fi
if [ -n "$HELP" ]
then
  echo "kube_upgrade.sh [-u <desired_version> | -l ]"
  echo "-u: upgrade to the desired version"
  echo "-l: List available versions"
  echo "-h: this help"
  exit 0
fi
CONTROL_PLANE_NODES=$(kubectl get nodes| grep control | cut -d ' ' -f1 )
WORKER_NODES=$(kubectl get nodes | grep worker| cut -d ' ' -f1 )


UPGRADE_APPLY=1
for n in $CONTROL_PLANE_NODES; do
   upgrade $n ${TARGET_VERSION} ${UPGRADE_APPLY} ${LIST_VERSIONS}
  UPGRADE_APPLY=0
done

for n in $WORKER_NODES; do
  upgrade $n ${TARGET_VERSION} 0
done
