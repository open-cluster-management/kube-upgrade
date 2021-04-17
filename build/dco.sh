#!/bin/bash
# Copyright Contributors to the Open Cluster Management project
set -x
BRANCH=$(git branch --show-current)
COMMITS=$(git log origin/main..${BRANCH} | grep commit | cut -d ' ' -f2)
for c in ${COMMITS}
do
  COMMIT=$(git show ${c} -q)
  if echo ${COMMIT} | grep Signed-off-by > /dev/null
  then
     ERROR=${ERROR}"commit id ${c} not signed\n"
  fi
done
if [ "${ERROR}" != "" ]
then
    echo ${ERROR}
    exit 1
else
    echo "All commits signed"
fi