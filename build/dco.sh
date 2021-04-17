#!/bin/bash
# Copyright Contributors to the Open Cluster Management project

BRANCH=$(git branch --show-current)
COMMITS=$(git log origin/main..${BRANCH} | grep commit | cut -d ' ' -f2)
for c in ${COMMITS}
do
  COMMIT=$(git show ${c})
  echo ${COMMIT} | grep Signed-off-by > /dev/null
  if [ $? != 0 ]
  then
     echo "${c} not signed"
     exit 1
  fi
done
echo "All commits signed"