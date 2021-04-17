#!/bin/bash
# Copyright Contributors to the Open Cluster Management project
# set -x
set -e
BRANCH=$1
echo "Check all commit signed on branch: ${BRANCH}"
COMMITS=$(git log origin/main..${BRANCH} -- | grep commit | cut -d ' ' -f2)
for c in ${COMMITS}
do
  COMMIT=$(git show ${c} -q)
  if ! echo "${COMMIT}" | grep Signed-off-by > /dev/null
  then
     ERROR="${ERROR}commit id ${c} not signed\n"
  fi
done
if [ "${ERROR}" != "" ]
then
    echo -e "${ERROR}"
    exit 1
else
    echo "All commits signed"
fi