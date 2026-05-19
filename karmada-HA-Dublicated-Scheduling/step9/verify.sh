#!/bin/bash

set -e

karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get deployment nginx | grep '2/1'
kubectl --kubeconfig $HOME/.kube/config-member1 get pods -l app=nginx | grep Running 
kubectl --kubeconfig $HOME/.kube/config-member2 get pods -l app=nginx | grep Running
