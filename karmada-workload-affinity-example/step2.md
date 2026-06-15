# Step 2 — Deploy Workloads with Workload Affinity

In this step you will deploy two Deployments — `frontend` and `backend` — that both carry
the label `app: shop`. By setting `workloadAffinity.affinity.groupByLabelKey: app` in each
`PropagationPolicy`, the Karmada scheduler will guarantee that **both workloads land on the
same member cluster**.

## Task

### 2a — Create the Deployments

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: default
  labels:
    app: shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: shop
      tier: frontend
  template:
    metadata:
      labels:
        app: shop
        tier: frontend
    spec:
      containers:
        - name: nginx
          image: nginx:stable-alpine
          ports:
            - containerPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: default
  labels:
    app: shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: shop
      tier: backend
  template:
    metadata:
      labels:
        app: shop
        tier: backend
    spec:
      containers:
        - name: httpbin
          image: kennethreitz/httpbin
          ports:
            - containerPort: 80
EOF
```

### 2b — Create the PropagationPolicies with Workload Affinity

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f - <<'EOF'
apiVersion: policy.karmada.io/v1alpha1
kind: PropagationPolicy
metadata:
  name: frontend-policy
  namespace: default
spec:
  resourceSelectors:
    - apiVersion: apps/v1
      kind: Deployment
      name: frontend
  placement:
    clusterAffinity:
      clusterNames:
        - member1
        - member2
        - member3
    workloadAffinity:
      affinity:
        groupByLabelKey: app
---
apiVersion: policy.karmada.io/v1alpha1
kind: PropagationPolicy
metadata:
  name: backend-policy
  namespace: default
spec:
  resourceSelectors:
    - apiVersion: apps/v1
      kind: Deployment
      name: backend
  placement:
    clusterAffinity:
      clusterNames:
        - member1
        - member2
        - member3
    workloadAffinity:
      affinity:
        groupByLabelKey: app
EOF
```

### 2c — Watch the ResourceBindings

The Karmada scheduler creates a `ResourceBinding` for each propagated resource. Watch them
appear and check that both show the **same** cluster under `SCHEDULED CLUSTER`:

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config \
  get resourcebindings -n default -w
```

Press `Ctrl+C` once both `frontend-deployment` and `backend-deployment` appear.

You can also inspect a binding in detail:

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config \
  describe resourcebinding frontend-deployment -n default
```

## Verify

The check script waits up to 120 seconds for both `ResourceBinding` objects to appear and
confirms that `.spec.clusters[0].name` is identical for `frontend-deployment` and
`backend-deployment`. Click **Check** once you have applied all the manifests above.
