#!/bin/bash
set -e

kubectl --kubeconfig=$HOME/.kube/config-member1 config get-contexts kind-member1
kubectl --kubeconfig=$HOME/.kube/config-member2 config get-contexts kind-member2
