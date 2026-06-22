### Deploy FlinkDeployment Application

Now let's deploy the FlinkDeployment workload to the Karmada control plane and define a policy to schedule it.

**Deploy the FlinkDeployment Custom Resource and PropagationPolicy:**

<details>
<summary>flinkdeployment-cr.yaml</summary>

```yaml
apiVersion: flink.apache.org/v1beta1
kind: FlinkDeployment
metadata:
  name: flinkdeployment-sample
spec:
  flinkConfiguration:
    taskmanager.numberOfTaskSlots: "2"
  flinkVersion: v1_17
  image: flink:1.17
  job:
    args: []
    jarURI: local:///opt/flink/examples/streaming/StateMachineExample.jar
    parallelism: 2
    state: running
    upgradeMode: stateless
  jobManager:
    replicas: 1
    resource:
      cpu: 0.01
      memory: 1Mi
  serviceAccount: flink
  taskManager:
    resource:
      cpu: 0.02
      memory: 2Mi
```

</details>

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f /root/examples/flinkdeployment-cr.yaml`{{exec}}

This applies the FlinkDeployment Custom Resource.

This FlinkDeployment includes a JobManager (1 replica, 0.01 CPU, 1Mi memory) and a TaskManager.
The TaskManager replica count is automatically computed as 1 using `ceil(parallelism/numberOfTaskSlots)`, with resources of 0.02 CPU and 2Mi memory.

> **Note:** During scheduling, karmada-scheduler will filter out the cluster with sufficient resources based on node resources and quotas of member clusters. So in this scenario, we set the resource requests of FlinkDeployment as low as possible to ensure successful propagation.

<details>
<summary>flink-policy.yaml</summary>

```yaml
apiVersion: policy.karmada.io/v1alpha1
kind: PropagationPolicy
metadata:
  name: flink-propagation
spec:
  resourceSelectors:
    - apiVersion: flink.apache.org/v1beta1
      kind: FlinkDeployment
      name: flinkdeployment-sample
  placement:
    clusterAffinity:
      clusterNames:
        - kind-member1
        - kind-member2
    spreadConstraints:
      - spreadByField: cluster
        maxGroups: 1
        minGroups: 1
    replicaScheduling:
      replicaSchedulingType: Divided
      replicaDivisionPreference: Aggregated
```

</details>

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f /root/examples/flink-policy.yaml`{{exec}}

This applies the FlinkDeployment PropagationPolicy.

**Why this matters:**

A FlinkDeployment requires its `JobManager` and `TaskManager` components to communicate constantly. If Karmada schedules them on different clusters, cross-cluster network latency will severely degrade performance.

If you inspect `flink-policy.yaml` (expand the section above), you'll see a specific configuration designed to prevent this:

```yaml
    spreadConstraints:
      - spreadByField: cluster
        maxGroups: 1
        minGroups: 1
```

This configuration (`maxGroups: 1` combined with `Aggregated` preference) guarantees that all components of the FlinkDeployment workload will be scheduled atomistically. They will be co-located on the **same target cluster**, ensuring optimal performance while preventing resource fragmentation.
