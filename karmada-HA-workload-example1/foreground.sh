#!/usr/bin/env bash

# Source common setup functions and variables
source "$(dirname "$0")/../common-setup.sh"

# Scenario-specific function for nginx deployment (replicas=1, Duplicated)
function nginxDeployment() {
    cat << EOF > nginxDeployment.yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
          - image: nginx
            name: nginx
EOF
}

function propagationPolicy() {
    cat << EOF > propagationPolicy.yaml
    apiVersion: policy.karmada.io/v1alpha1
    kind: PropagationPolicy
    metadata:
      name: nginx-propagation
    spec:
      resourceSelectors:
        - apiVersion: apps/v1
          kind: Deployment
          name: nginx
      placement:
        clusterAffinity:
          clusterNames:
            - kind-member1
            - kind-member2
        replicaScheduling:
          replicaSchedulingType: Duplicated
EOF
}

# Setup kubectl environment
setupKubectl

# Generate configuration scripts and files
installKind
createCluster
cluster1Config
cluster2Config
copyConfigFilesToNode

# Generate nginx config
mkdir nginx
cd nginx
nginxDeployment
propagationPolicy

# Create clusters on remote node
createMemberClusters

# Install karmadactl
installKarmadactl

# Init karmada
karmadactl init

# Join member clusters
joinMemberClusters

# clean screen
clear
