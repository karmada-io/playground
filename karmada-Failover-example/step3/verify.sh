#!/bin/bash

taint_effect=$(kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get cluster kind-member2 -o jsonpath='{.spec.taints[?(@.key=="failover-test")].effect}')
if [ "$taint_effect" == "NoExecute" ]; then
		echo "Taint applied successfully to kind-member2."
else
		echo "Failed to apply taint to kind-member2."
		exit 1
fi
