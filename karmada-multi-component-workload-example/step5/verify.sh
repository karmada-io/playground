#!/bin/bash

kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get clusters kind-member1 && kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get clusters kind-member2
