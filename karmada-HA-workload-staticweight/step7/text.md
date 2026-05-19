# Create Deployment

**Create deployment named `nginx` with 3 replicas:**

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f ~/nginx/nginxDeployment.yaml`{{exec}}

Creates the nginx workload with defined replicas in the Karmada control plane.

**Verify deployment exists:**

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get deployment nginx`{{exec}}

This confirms that the nginx deployment exists in the control plane.
