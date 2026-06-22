#!/bin/bash

kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get flinkdeployment flinkdeployment-sample -n default &> /dev/null && kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get propagationpolicy flink-propagation -n default &> /dev/null
