# Step 4 — Observe and Inspect the Scheduling Decisions

Now that both sets of workloads are running you can use `kubectl` to inspect exactly what the
Karmada scheduler decided and understand how the `ResourceBinding` objects encode the
placement.

## Task

### 4a — List all ResourceBindings across all namespaces

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config \
  get resourcebindings -A
```

You should see four bindings:

| NAME | SCHEDULED CLUSTER |
|------|-------------------|
| `frontend-deployment` | e.g. `member2` |
| `backend-deployment`  | e.g. `member2` ← same as frontend |
| `service-a-deployment` | e.g. `member1` |
| `service-b-deployment` | e.g. `member3` ← different from service-a |

### 4b — Compare the affinity group

Describe the `frontend-deployment` and `backend-deployment` bindings side-by-side and note
that both `.spec.clusters[0].name` values are identical:

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config \
  describe resourcebinding frontend-deployment -n default
```

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config \
  describe resourcebinding backend-deployment -n default
```

### 4c — Compare the anti-affinity group

Describe the `service-a-deployment` and `service-b-deployment` bindings and note that
`.spec.clusters[0].name` values are **different**:

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config \
  describe resourcebinding service-a-deployment -n default
```

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config \
  describe resourcebinding service-b-deployment -n default
```

### 4d — Print a quick summary using jsonpath

Use `jsonpath` to print just the cluster assignments in one command:

```bash
for rb in frontend-deployment backend-deployment service-a-deployment service-b-deployment; do
  cluster=$(kubectl --kubeconfig /etc/karmada/karmada-apiserver.config \
    get resourcebinding "$rb" -n default \
    -o jsonpath='{.spec.clusters[0].name}')
  echo "$rb  →  $cluster"
done
```

## Verify

The check script confirms that all four `ResourceBinding` objects exist and have a non-empty
cluster assignment, and re-verifies both the affinity constraint (frontend == backend) and
the anti-affinity constraint (service-a != service-b). Click **Check** once you have
explored the bindings above.
