#!/bin/bash
set -e

karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get deployment
karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get pods --operation-scope members
