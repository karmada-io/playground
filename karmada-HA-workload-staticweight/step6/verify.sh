#!/bin/bash
set -e

kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get cluster kind-member1
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get cluster kind-member2
