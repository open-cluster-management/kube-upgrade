#!/bin/bash

# Copyright (c) 2020 Red Hat, Inc.
# Copyright Contributors to the Open Cluster Management project

ln -sf ../../build/git-hooks/pre-commit .git/hooks/pre-commit
ln -sf ../../build/git-hooks/post-commit .git/hooks/post-commit
