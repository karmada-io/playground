### Prepare member clusters

**Install Kind on the member node:**

RUN `ssh -o StrictHostKeyChecking=no root@172.30.2.2 "bash ~/installKind.sh"`{{exec}}

This command connects to node01 via SSH and installs Kind (Kubernetes in Docker), which is used to create local Kubernetes clusters.

**Create two clusters (`member1` and `member2`):**

RUN `ssh -o StrictHostKeyChecking=no root@172.30.2.2 "bash ~/createCluster.sh"`{{exec}}

This creates two Kubernetes clusters (`member1` and `member2`) and copies their kubeconfig files back to the host node.

> **Note:** This step may take **1–2 minutes** — wait for the prompt to return before proceeding.

**Verify clusters were created:**

RUN `ssh -o StrictHostKeyChecking=no root@172.30.2.2 "kind get clusters"`{{exec}}

Both `member1` and `member2` should appear in the output.
