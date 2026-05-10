# Step 3 — Deploy Workloads with Workload Anti-Affinity

Now you will deploy two Deployments — `service-a` and `service-b` — that both carry the
label `ha-group: my-app`. By setting `workloadAffinity.antiAffinity.groupByLabelKey: ha-group`
in each `PropagationPolicy`, the Karmada scheduler will guarantee that **the two workloads
land on different member clusters**, improving availability.

## Task

### 3a — Create the Deployments

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-a
  namespace: default
  labels:
    ha-group: my-app
spec:
  replicas: 1
  selector:
    matchLabels:
      ha-group: my-app
      component: service-a
  template:
    metadata:
      labels:
        ha-group: my-app
        component: service-a
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
  name: service-b
  namespace: default
  labels:
    ha-group: my-app
spec:
  replicas: 1
  selector:
    matchLabels:
      ha-group: my-app
      component: service-b
  template:
    metadata:
      labels:
        ha-group: my-app
        component: service-b
    spec:
      containers:
        - name: nginx
          image: nginx:stable-alpine
          ports:
            - containerPort: 80
EOF
```

### 3b — Create the PropagationPolicies with Workload Anti-Affinity

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f - <<'EOF'
apiVersion: policy.karmada.io/v1alpha1
kind: PropagationPolicy
metadata:
  name: service-a-policy
  namespace: default
spec:
  resourceSelectors:
    - apiVersion: apps/v1
      kind: Deployment
      name: service-a
  placement:
    clusterAffinity:
      clusterNames:
        - member1
        - member2
        - member3
    workloadAffinity:
      antiAffinity:
        groupByLabelKey: ha-group
---
apiVersion: policy.karmada.io/v1alpha1
kind: PropagationPolicy
metadata:
  name: service-b-policy
  namespace: default
spec:
  resourceSelectors:
    - apiVersion: apps/v1
      kind: Deployment
      name: service-b
  placement:
    clusterAffinity:
      clusterNames:
        - member1
        - member2
        - member3
    workloadAffinity:
      antiAffinity:
        groupByLabelKey: ha-group
EOF
```

### 3c — Watch the ResourceBindings

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config \
  get resourcebindings -n default -w
```

Press `Ctrl+C` once `service-a-deployment` and `service-b-deployment` appear. Notice that
the `SCHEDULED CLUSTER` column shows **different** clusters for the two services.

You can also confirm by describing each binding:

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config \
  describe resourcebinding service-a-deployment -n default

kubectl --kubeconfig /etc/karmada/karmada-apiserver.config \
  describe resourcebinding service-b-deployment -n default
```

## Verify

The check script waits up to 120 seconds for both `ResourceBinding` objects to appear and
confirms that `.spec.clusters[0].name` is **different** for `service-a-deployment` and
`service-b-deployment`. Click **Check** once you have applied all the manifests above.
