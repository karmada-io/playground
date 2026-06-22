#!/bin/bash

set -e

# Wait for ResourceBinding to be created
for i in $(seq 1 20); do
  BINDING_NAME=$(kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get resourcebinding -n default -o json | jq -r '.items[] | select(.spec.resource.kind=="FlinkDeployment") | .metadata.name // empty')
  [ -n "$BINDING_NAME" ] && break
  sleep 3
done
[ -z "$BINDING_NAME" ] && exit 1

for i in $(seq 1 20); do
  karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get flinkdeployment --operation-scope members | grep "flinkdeployment-sample" &> /dev/null && break
  sleep 3
done
karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get flinkdeployment --operation-scope members | grep "flinkdeployment-sample" &> /dev/null || exit 1
