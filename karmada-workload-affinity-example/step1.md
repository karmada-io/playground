# Step 1 — Verify the Karmada Environment

Before deploying any workloads you need to confirm that all three member clusters are
registered with the Karmada control plane and in a `Ready` state.

## Task

List all clusters known to Karmada:

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get clusters
```

Expected output (all three clusters must show `Ready = True`):

```
NAME      VERSION   MODE   READY   AGE
member1   v1.xx.x   Push   True    Xm
member2   v1.xx.x   Push   True    Xm
member3   v1.xx.x   Push   True    Xm
```

If you want to inspect a specific cluster in detail:

```bash
kubectl --kubeconfig /etc/karmada/karmada-apiserver.config \
  describe cluster member1
```

Look for the `Conditions` section and confirm `Ready` is `True`.

## Verify

The check script queries each cluster object and verifies its `Ready` condition. Click
**Check** once all three clusters appear as `Ready`.
