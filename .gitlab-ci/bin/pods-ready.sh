#!/usr/bin/env bash

# Taken from https://github.com/zlabjp/kubernetes-scripts/blob/master/wait-until-pods-ready
# Modified by mpotter 2/25/2019 to take namespace argument.
#
# Copyright 2017, Z Lab Corporation. All rights reserved.
# Copyright 2017, Kubernetes scripts contributors
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.

# Usage: wait-until-pods-ready RELEASE PERIOD INTERVAL
# RELEASE is used to filter the pods that need to be checked.
# Namespace of PROJECT_NAME-project is used if KUBE_NAMESPACE is not set.
# PERIOD defaults to 240
# INTERVAL defaults to 10

RELEASE="$1"

set -e

if [ -z ${KUBE_NAMESPACE} ]; then
  KUBE_NAMESPACE=${PROJECT_NAME}-project
fi

function __is_pod_ready() {
  [[ "$(kubectl get pod "$1" ${NAMESPACE} -o 'jsonpath={.status.conditions[?(@.type=="Ready")].status}')" == 'True' ]]
}

function __pods_ready() {
  local pod

  [[ "$#" == 0 ]] && return 0

  for pod in $pods; do
    __is_pod_ready "$pod" || return 1
  done

  return 0
}

function __list_pods() {
  kubectl get pods ${NAMESPACE} -l release=${RELEASE}
}

function __label_pods() {
# Ensure pods that match our release all have a release label.
# Pods created in our deployment will already have this, but pods based on
# other charts, such as mariadb won't have this label.
  pods="$(kubectl get pods ${NAMESPACE} -o 'jsonpath={.items[*].metadata.name}')"
  for pod in $pods; do
    if [[ $pod == $RELEASE-* ]]; then
      kubectl label pod $pod release=${RELEASE} --overwrite &> /dev/null
    fi
  done
}

function __wait-until-pods-ready() {
  local period interval i pods

  period="${2:-240}"
  interval="${3:-10}"

  if [[ ${KUBE_NAMESPACE} != "" ]]; then
    NAMESPACE="-n ${KUBE_NAMESPACE}"
  fi

  __label_pods
  __list_pods

  for ((i=0; i<$period; i+=$interval)); do
    pods="$(kubectl get pods ${NAMESPACE} -o 'jsonpath={.items[*].metadata.name}' -l release=${RELEASE})"
    if __pods_ready $pods; then
      return 0
    fi

    echo "Waiting for pods to be ready..."
    sleep "$interval"
  done

  echo "Waited for $period seconds, but all pods are not ready yet."
  __list_pods
  return 1
}

__wait-until-pods-ready $@
# vim: ft=sh :
