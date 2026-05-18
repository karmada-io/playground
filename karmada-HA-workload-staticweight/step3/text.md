# Initialize Karmada

**Initialize Karmada control plane:**

RUN `karmadactl init`{{exec}}

This bootstraps the Karmada control plane on the host cluster.

> **Note:** `karmadactl init` deploys etcd, the Karmada API server, scheduler, and controller manager. This takes approximately **2–3 minutes** — wait for the prompt to return before proceeding.

**Verify initialization:**

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config config get-contexts karmada-apiserver`{{exec}}

This confirms the Karmada API server context is available.
