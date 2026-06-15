#!/usr/bin/env bash
set -euo pipefail

KUBECONFIG=/etc/karmada/karmada-apiserver.config

for cluster in member1 member2 member3; do
  status=$(kubectl --kubeconfig "$KUBECONFIG" \
    get cluster "$cluster" \
    -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || echo "")

  if [ "$status" != "True" ]; then
    echo "FAIL: cluster '$cluster' is not Ready (got: '${status:-<not found>}')"
    exit 1
  fi
done

echo "PASS: member1, member2, and member3 are all Ready."
exit 0
