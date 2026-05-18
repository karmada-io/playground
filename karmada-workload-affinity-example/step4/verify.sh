#!/usr/bin/env bash
set -euo pipefail

KUBECONFIG=/etc/karmada/karmada-apiserver.config
FAILED=0

get_cluster() {
  kubectl --kubeconfig "$KUBECONFIG" \
    get resourcebinding "$1" -n default \
    -o jsonpath='{.spec.clusters[0].name}' 2>/dev/null || echo ""
}

# ── Check all four ResourceBindings exist and are bound ──────────────────────
for rb in frontend-deployment backend-deployment service-a-deployment service-b-deployment; do
  cluster=$(get_cluster "$rb")
  if [ -z "$cluster" ]; then
    echo "FAIL: ResourceBinding '$rb' is missing or has no cluster assignment."
    FAILED=1
  else
    echo "OK:   $rb  →  $cluster"
  fi
done

[ "$FAILED" -eq 1 ] && exit 1

# ── Re-verify affinity constraint: frontend == backend ───────────────────────
frontend_cluster=$(get_cluster frontend-deployment)
backend_cluster=$(get_cluster backend-deployment)

if [ "$frontend_cluster" != "$backend_cluster" ]; then
  echo "FAIL: affinity constraint violated — frontend is on '$frontend_cluster' but backend is on '$backend_cluster'."
  exit 1
fi
echo "OK:   affinity satisfied  — frontend and backend are both on '$frontend_cluster'."

# ── Re-verify anti-affinity constraint: service-a != service-b ───────────────
servicea_cluster=$(get_cluster service-a-deployment)
serviceb_cluster=$(get_cluster service-b-deployment)

if [ "$servicea_cluster" = "$serviceb_cluster" ]; then
  echo "FAIL: anti-affinity constraint violated — service-a and service-b are both on '$servicea_cluster'."
  exit 1
fi
echo "OK:   anti-affinity satisfied — service-a is on '$servicea_cluster', service-b is on '$serviceb_cluster'."

echo ""
echo "PASS: all four ResourceBindings are present and scheduling constraints are satisfied."
exit 0
