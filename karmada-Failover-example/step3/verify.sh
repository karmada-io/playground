#!/bin/bash

set -e

kubectl --kubeconfig /etc/karmada/karmada-apiserver.config config get-contexts karmada-apiserver
