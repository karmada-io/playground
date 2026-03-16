#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Common variable definitions
kind_version=v0.17.0
host_cluster_ip=172.30.1.2  # host node where Karmada is located
member_cluster_ip=172.30.2.2
local_ip=127.0.0.1
KUBECONFIG_PATH=${KUBECONFIG_PATH:-"${HOME}/.kube"}

# Install Kind binary
function installKind() {
    cat << EOF > installKind.sh
    wget https://github.com/kubernetes-sigs/kind/releases/download/${kind_version}/kind-linux-amd64
    chmod +x kind-linux-amd64
    sudo mv kind-linux-amd64 /usr/local/bin/kind
EOF
}

# Create member clusters script
function createCluster() {
    cat << EOF > createCluster.sh
    kind create cluster --name=member1 --config=cluster1.yaml
    mv \$HOME/.kube/config ~/config-member1
    kind create cluster --name=member2 --config=cluster2.yaml
    mv \$HOME/.kube/config config-member2
    KUBECONFIG=~/config-member1:~/config-member2 kubectl config view --merge --flatten >> ${KUBECONFIG_PATH}/config
    # modify ip
    sed -i "s/${local_ip}/${member_cluster_ip}/g"  config-member1
    # set StrictHostKeyChecking to no to avoid prompting, the same below
    scp -o StrictHostKeyChecking=no config-member1 root@${host_cluster_ip}:\$HOME/.kube/config-member1
    sed -i "s/${local_ip}/${member_cluster_ip}/g"  config-member2
    scp -o StrictHostKeyChecking=no config-member2 root@${host_cluster_ip}:\$HOME/.kube/config-member2
EOF
}

# Generate cluster1 configuration
function cluster1Config() {
    cat << EOF > cluster1.yaml
    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    networking:
      apiServerAddress: "${member_cluster_ip}"
      apiServerPort: 6443
EOF
}

# Generate cluster2 configuration
function cluster2Config() {
    cat << EOF > cluster2.yaml
    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    networking:
      apiServerAddress: "${member_cluster_ip}"
      apiServerPort: 6444
EOF
}

# Copy configuration files to member cluster node
function copyConfigFilesToNode() {
    scp -o StrictHostKeyChecking=no \
        installKind.sh \
        createCluster.sh \
        cluster1.yaml \
        cluster2.yaml \
        root@${member_cluster_ip}:~
}

# Setup kubectl environment
function setupKubectl() {
    kubectl delete node node01
    kubectl taint node controlplane node-role.kubernetes.io/control-plane:NoSchedule-
}

# Create member clusters on remote node
function createMemberClusters() {
    ssh -o StrictHostKeyChecking=no root@${member_cluster_ip} "bash ~/installKind.sh" &
    sleep 10
    ssh -o StrictHostKeyChecking=no root@${member_cluster_ip} "bash ~/createCluster.sh" &
    sleep 90
}

# Install karmadactl CLI
function installKarmadactl() {
    curl -s https://raw.githubusercontent.com/karmada-io/karmada/master/hack/install-cli.sh | sudo bash
}

# Join member clusters to Karmada
function joinMemberClusters() {
    MEMBER_CLUSTER_NAME=kind-member1
    karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config join ${MEMBER_CLUSTER_NAME} --cluster-kubeconfig=$HOME/.kube/config-member1 --cluster-context=kind-member1
    MEMBER_CLUSTER_NAME=kind-member2
    karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config join ${MEMBER_CLUSTER_NAME} --cluster-kubeconfig=$HOME/.kube/config-member2 --cluster-context=kind-member2
}
