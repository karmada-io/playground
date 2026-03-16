#!/usr/bin/env bash

# Source common setup functions and variables
source "$(dirname "$0")/../common-setup.sh"

# Setup kubectl environment
setupKubectl

# Generate configuration scripts and files
installKind
createCluster
cluster1Config
cluster2Config
copyConfigFilesToNode

# Create clusters on remote node
ssh -o StrictHostKeyChecking=no root@${member_cluster_ip} "bash ~/installKind.sh" &
sleep 10
ssh -o StrictHostKeyChecking=no root@${member_cluster_ip} "bash ~/createCluster.sh"

# clean screen
clear
