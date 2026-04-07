### Initialize Karmada control plane

**Initialize Karmada control plane:**

RUN `karmadactl init`{{exec}}

This sets up the Karmada control plane on the host cluster, including API server and controllers.

**Verify initialization:**

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config config get-contexts karmada-apiserver`{{exec}}

This ensures that the Karmada API server context is available and configured correctly.
