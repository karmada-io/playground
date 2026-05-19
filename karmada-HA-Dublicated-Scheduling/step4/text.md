# Prepare Member Clusters

With the Karmada control plane running, you can now create the member clusters on `node01`.

**Install Kind on member node:**

RUN `ssh -o StrictHostKeyChecking=no root@172.30.2.2 "bash ~/installKind.sh"`{{exec}}

This installs Kind on the remote node to enable creation of Kubernetes clusters.

**Create member clusters:**

RUN `ssh -o StrictHostKeyChecking=no root@172.30.2.2 "bash ~/createCluster.sh"`{{exec}}

This creates two Kubernetes member clusters (`member1` and `member2`) using Kind, and copies their kubeconfig files to the controlplane node.

> **Note:** This step may take **1–2 minutes** — wait for the prompt to return before proceeding.

**Verify clusters were created:**

RUN `ssh -o StrictHostKeyChecking=no root@172.30.2.2 "kind get clusters"`{{exec}}

Both `member1` and `member2` should appear in the output.
