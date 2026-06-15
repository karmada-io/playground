# Congratulations!

You have successfully completed the **Workload Affinity and Anti-Affinity Scheduling**
scenario for Karmada v1.17.

## What You Accomplished

| Step | What you did | Outcome |
|------|-------------|---------|
| 1 | Verified all three member clusters were `Ready` | Healthy multi-cluster foundation |
| 2 | Deployed `frontend` + `backend` with **affinity** (`groupByLabelKey: app`) | Both landed on the **same** cluster |
| 3 | Deployed `service-a` + `service-b` with **anti-affinity** (`groupByLabelKey: ha-group`) | Each landed on a **different** cluster |
| 4 | Inspected `ResourceBinding` objects | Confirmed all scheduling decisions |

## Key Takeaways

**Workload Affinity** is useful when:
- Services communicate frequently and cross-cluster traffic is expensive.
- You want all components of a micro-service tier to share the same failure domain.

**Workload Anti-Affinity** is useful when:
- You run active-active replicas and need them spread across failure domains.
- Regulations require geographic or infrastructure separation between instances.

**The `groupByLabelKey` field** is the glue: the scheduler groups every `PropagationPolicy`
that references the same key and treats them as a single scheduling unit for affinity /
anti-affinity decisions.

## Cleaning Up

To remove everything created during this scenario:

```bash
KUBECONFIG=/etc/karmada/karmada-apiserver.config

# Delete workloads and policies from step 2
kubectl --kubeconfig $KUBECONFIG delete deployment frontend backend -n default
kubectl --kubeconfig $KUBECONFIG delete propagationpolicy frontend-policy backend-policy -n default

# Delete workloads and policies from step 3
kubectl --kubeconfig $KUBECONFIG delete deployment service-a service-b -n default
kubectl --kubeconfig $KUBECONFIG delete propagationpolicy service-a-policy service-b-policy -n default
```

## What to Explore Next

- **SpreadConstraint** — combine affinity rules with `maxClusters` / `minClusters` for
  fine-grained spread control.
- **PropagationPolicy weights** — influence which cluster a group lands on when multiple
  clusters are eligible.
- **ClusterOverridePolicy** — apply cluster-specific patches on top of affinity-placed
  workloads.

For more details see the [Karmada documentation](https://karmada.io/docs/).
