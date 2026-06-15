#!/usr/bin/env bash
set -euo pipefail

KUBECONFIG=/etc/karmada/karmada-apiserver.config
TIMEOUT=120
INTERVAL=5
elapsed=0

echo "Waiting for frontend-deployment and backend-deployment ResourceBindings to be scheduled..."

while [ "$elapsed" -lt "$TIMEOUT" ]; do
  frontend_cluster=$(kubectl --kubeconfig "$KUBECONFIG" \
    get resourcebinding frontend-deployment -n default \
    -o jsonpath='{.spec.clusters[0].name}' 2>/dev/null || echo "")

  backend_cluster=$(kubectl --kubeconfig "$KUBECONFIG" \
    get resourcebinding backend-deployment -n default \
    -o jsonpath='{.spec.clusters[0].name}' 2>/dev/null || echo "")

  if [ -n "$frontend_cluster" ] && [ -n "$backend_cluster" ]; then
    if [ "$frontend_cluster" = "$backend_cluster" ]; then
      echo "PASS: frontend and backend are both scheduled on cluster '$frontend_cluster'."
      exit 0
    else
      echo "FAIL: workload affinity violated — frontend is on '$frontend_cluster' but backend is on '$backend_cluster'."
      exit 1
    fi
  fi

  echo "  ResourceBindings not yet scheduled (${elapsed}s elapsed). Retrying in ${INTERVAL}s..."
  sleep "$INTERVAL"
  elapsed=$((elapsed + INTERVAL))
done

echo "FAIL: timed out after ${TIMEOUT}s waiting for ResourceBindings to be scheduled."
exit 1
