# Create deployment

**Create deployment named `nginx` with 1 replica:**

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f ~/nginx/nginxDeployment.yaml`{{exec}}

<details>
<summary> nginxDeployment.yaml</summary>

```yaml
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
```

</details>

Creates the nginx workload in the Karmada control plane. With Duplicated scheduling, this single replica definition will be copied to every member cluster.

**Verify deployment exists:**

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get deployment nginx`{{exec}}

This confirms that the nginx deployment exists in the control plane.