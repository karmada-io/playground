#!/usr/bin/env bash
set -euo pipefail

KUBECONFIG=/etc/karmada/karmada-apiserver.config
TIMEOUT=120
INTERVAL=5
elapsed=0

echo "Waiting for service-a-deployment and service-b-deployment ResourceBindings to be scheduled..."

while [ "$elapsed" -lt "$TIMEOUT" ]; do
  servicea_cluster=$(kubectl --kubeconfig "$KUBECONFIG" \
    get resourcebinding service-a-deployment -n default \
    -o jsonpath='{.spec.clusters[0].name}' 2>/dev/null || echo "")

  serviceb_cluster=$(kubectl --kubeconfig "$KUBECONFIG" \
    get resourcebinding service-b-deployment -n default \
    -o jsonpath='{.spec.clusters[0].name}' 2>/dev/null || echo "")

  if [ -n "$servicea_cluster" ] && [ -n "$serviceb_cluster" ]; then
    if [ "$servicea_cluster" != "$serviceb_cluster" ]; then
      echo "PASS: workload anti-affinity enforced — service-a is on '$servicea_cluster', service-b is on '$serviceb_cluster'."
      exit 0
    else
      echo "FAIL: workload anti-affinity violated — both service-a and service-b are on '$servicea_cluster'."
      exit 1
    fi
  fi

  echo "  ResourceBindings not yet scheduled (${elapsed}s elapsed). Retrying in ${INTERVAL}s..."
  sleep "$INTERVAL"
  elapsed=$((elapsed + INTERVAL))
done

echo "FAIL: timed out after ${TIMEOUT}s waiting for ResourceBindings to be scheduled."
exit 1
