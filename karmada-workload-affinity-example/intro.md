# Workload Affinity and Anti-Affinity Scheduling in Karmada

Karmada v1.17 introduces **Workload Affinity** and **Workload Anti-Affinity** scheduling — a
mechanism for controlling how groups of workloads are co-located or spread across your
multi-cluster fleet based on shared labels.

## Why This Matters

In a multi-cluster setup you often face two opposing requirements:

| Goal | Mechanism |
|------|-----------|
| Services that talk to each other should land on the **same** cluster (low latency, no cross-cluster traffic) | **Workload Affinity** |
| Redundant services should land on **different** clusters (high availability, fault isolation) | **Workload Anti-Affinity** |

Before v1.17 you had to hard-code `clusterNames` in every policy to achieve this. Now the
scheduler handles it automatically by grouping workloads on a shared label key.

## How It Works

Rules live inside a `PropagationPolicy` under `.spec.placement.workloadAffinity`:

```yaml
placement:
  workloadAffinity:
    affinity:              # OR antiAffinity
      groupByLabelKey: app # label key used to group workloads
```

The scheduler finds all workloads whose `PropagationPolicy` references the same
`groupByLabelKey` and:
- **affinity** — schedules them all on the cluster already chosen by the group.
- **antiAffinity** — spreads them so no two workloads in the group share a cluster.

## What You Will Do

1. Verify that all three member clusters are healthy.
2. Deploy `frontend` + `backend` with **affinity** and confirm they land on the same cluster.
3. Deploy `service-a` + `service-b` with **anti-affinity** and confirm they land on different clusters.
4. Inspect the `ResourceBinding` objects to see exactly which cluster each workload was assigned to.

## Environment

The background setup script is now installing Karmada (this takes a few minutes). Once the
terminal is unlocked, all three member clusters — `member1`, `member2`, and `member3` — will
be joined and the `WorkloadAffinity` feature gate will be active.
