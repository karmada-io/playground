#!/bin/bash

kubectl -n karmada-system get deployment karmada-controller-manager -o json | jq -r '.spec.template.spec.containers[0].command[]' | grep -q "MultiplePodTemplatesScheduling=true" && kubectl -n karmada-system get deployment karmada-webhook -o json | jq -r '.spec.template.spec.containers[0].command[]' | grep -q "MultiplePodTemplatesScheduling=true"
