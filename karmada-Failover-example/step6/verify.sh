#!/usr/bin/env bash

set -e
set -o errexit
set -o nounset
set -o pipefail

NAMESPACE=${NAMESPACE:-karmada-system}

# Use the default kubeconfig (Host Cluster) where the deployment actually lives
args=$(kubectl -n "$NAMESPACE" get deployment karmada-controller-manager -o jsonpath='{.spec.template.spec.containers[0].command}')

if echo "$args" | grep -q 'Failover=true'; then
  echo "Failover feature gate is present"
else
  echo "Failover feature gate NOT found"
  exit 1
fi

if echo "$args" | grep -q 'GracefulEviction=true'; then
  echo "GracefulEviction feature gate is present"
else
  echo "GracefulEviction feature gate NOT found"
  exit 1
fi

if echo "$args" | grep -q 'enable-no-execute-taint-eviction=true'; then
  echo "Taint eviction flag is present"
else
  echo "Taint eviction flag NOT found"
  exit 1
fi

echo "Feature gates verified"
