# Create PropagationPolicy with Duplicated mode

**Create PropagationPolicy for `nginx` with Duplicated scheduling:**

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f ~/nginx/propagationPolicy.yaml`{{exec}}

<details>
<summary> PropagationPolicy.yaml</summary>

```yaml
apiVersion: policy.karmada.io/v1alpha1
kind: PropagationPolicy
metadata:
  name: nginx-propagation  
spec:
  resourceSelectors:
    - apiVersion: apps/v1
      kind: Deployment
      name: nginx
  placement:
    clusterAffinity:
      clusterNames:
        - kind-member1
        - kind-member2
    replicaScheduling:
      replicaSchedulingType: Duplicated
```

</details>

This applies a policy that propagates the full nginx deployment to every member cluster listed in `clusterAffinity`. With `replicaSchedulingType: Duplicated`, each cluster receives its own independent copy of the deployment — no replica splitting occurs.

- kind-member1: 1 full copy (1 pod)
- kind-member2: 1 full copy (1 pod)

**Verify policy exists:**

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get propagationpolicy nginx-propagation`{{exec}}

This checks that the propagation policy has been successfully created.
