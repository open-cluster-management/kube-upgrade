# Copyright Contributors to the Open Cluster Management project

BEFORE_SCRIPT := $(shell build/before-make.sh)

SCRIPTS_PATH ?= build

# Install software dependencies
INSTALL_DEPENDENCIES ?= ${SCRIPTS_PATH}/install-dependencies.sh

export PROJECT_DIR            = $(shell 'pwd')
export PROJECT_NAME			  = $(shell basename ${PROJECT_DIR})

.PHONY: deps
deps:
	@$(INSTALL_DEPENDENCIES)

.PHONY: oc-plugin
oc-plugin: build
	mv ${GOPATH}/bin/cm ${GOPATH}/bin/oc_cm

.PHONY: kubectl-plugin
kubectl-plugin: build
	mv ${GOPATH}/bin/cm ${GOPATH}/bin/kubectl_cm

.PHONY: check
## Runs a set of required checks
check: check-copyright

.PHONY: check-copyright
check-copyright:
	@build/check-copyright.sh

.PHONY: dco
dco:
	@build/dco.sh ${BRANCH_NAME}

.PHONY: test
test:
	@build/run-unit-tests.sh

.PHONY: functional-test-full
functional-test-full: deps 
	@build/run-functional-tests.sh
