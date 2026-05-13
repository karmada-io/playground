### Prepare member clusters

**Install Kind on the member node:**

RUN `ssh -o StrictHostKeyChecking=no root@172.30.2.2 "bash ~/installKind.sh"`{{exec}}

This command connects to node01 via SSH and installs Kind (Kubernetes in Docker), which is used to create local Kubernetes clusters.

**Create two clusters (`member1` and `member2`):**

RUN `ssh -o StrictHostKeyChecking=no root@172.30.2.2 "bash ~/createCluster.sh"`{{exec}}

This script creates two Kubernetes clusters (`member1` and `member2`) and copies their kubeconfig files back to the host node.
This step may take 1-2 minutes.

**Verify clusters:**

RUN `kubectl --kubeconfig=$HOME/.kube/config-member1 config get-contexts kind-member1`{{exec}}

This verifies that the member1 cluster context is correctly configured.

RUN `kubectl --kubeconfig=$HOME/.kube/config-member2 config get-contexts kind-member2`{{exec}}

This verifies that the member2 cluster context is available.
