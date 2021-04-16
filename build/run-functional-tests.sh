#!/bin/bash
# Copyright Contributors to the Open Cluster Management project

# set -x
set -e
TEST_DIR=test/functional
TEST_RESULT_DIR=$TEST_DIR/tmp
ERROR_REPORT=""
CLUSTER_NAME=$PROJECT_NAME-functional-test
export KUBECONFIG=$TEST_DIR/tmp/kind.yaml

rm -rf $TEST_RESULT_DIR
mkdir -p $TEST_RESULT_DIR

upgrade() {
   CURRENT_VERSION=$1
   TARGET_VERSION=$2
   kind create cluster --name ${CLUSTER_NAME}-${CURRENT_VERSION} --config ${TEST_DIR}/kind${CURRENT_VERSION}.yaml
   ./kube_upgrade.sh -u ${TARGET_VERSION}
   FINAL_VERSION=$(kubectl version | grep Server | cut -d ',' -f3 | cut -d ':' -f2 | tr -d '"')
   if [ "${FINAL_VERSION}" != "v${TARGET_VERSION}" ]
   then
      ERROR_REPORT=$ERROR_REPORT+"Expected ${TARGET_VERSION}, got ${FINAL_VERSION}\n"
   fi
   kind delete cluster  --name ${CLUSTER_NAME}-${CURRENT_VERSION}
}

# upgrade 115 1.16.0
# upgrade 117 1.18.0
# upgrade 118 1.19.0
# upgrade 119 1.20.0
upgrade 120 1.21.0

if [ -z "$ERROR_REPORT" ]
then
    echo "Success"
else
    echo -e "\n\nErrors\n======\n"$ERROR_REPORT
    exit 1
fi
