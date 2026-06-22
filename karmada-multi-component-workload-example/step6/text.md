### Provide Workload Definitions to Karmada

Before Karmada can schedule complex FlinkDeployment workloads, it needs to understand their structure.

To achieve this, we must apply their **Custom Resource Definitions (CRDs)** to the Karmada control plane and propagate them to the member clusters.

> **Note:** Karmada has built-in support for interpreting FlinkDeployment workloads. It automatically handles extraction of each component's replicas and resource requirements, so no manual Resource Interpreter is needed.

**Apply the CRDs and PropagationPolicy:**

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f /root/examples/flinkdeployments.flink.apache.org-v1.yaml`{{exec}}

This applies the FlinkDeployment CRD.

<details>
<summary>crd-propagation-policy.yaml</summary>

```yaml
apiVersion: policy.karmada.io/v1alpha1
kind: ClusterPropagationPolicy
metadata:
  name: crd-propagation
spec:
  resourceSelectors:
    - apiVersion: apiextensions.k8s.io/v1
      kind: CustomResourceDefinition
      name: flinkdeployments.flink.apache.org
  placement:
    clusterAffinity:
      clusterNames:
        - kind-member1
        - kind-member2
```

</details>

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f /root/examples/crd-propagation-policy.yaml`{{exec}}

This applies the ClusterPropagationPolicy to distribute the CRDs.


**Verify CRD Propagation:**

Wait a moment for the Karmada controller to sync, then query `member1` directly to ensure the FlinkDeployment CRD was successfully pushed down to the edge cluster:

RUN `kubectl --kubeconfig=$HOME/.kube/config-member1 get crd flinkdeployments.flink.apache.org`{{exec}}

This outputs the `flinkdeployments.flink.apache.org` CRD, showing it was successfully pushed to the edge cluster.
