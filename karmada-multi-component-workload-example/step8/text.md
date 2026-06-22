### Inspect the FlinkDeployment ResourceBinding

When you apply a workload, Karmada uses its Resource Interpreter to analyze the custom resource, extract its requirements, and wrap it into a `ResourceBinding`. Let's inspect this binding to see what Karmada discovered.

First, extract the dynamic binding name into a variable:

RUN `BINDING_NAME=$(kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get resourcebinding -n default -o json | jq -r '.items[] | select(.spec.resource.kind=="FlinkDeployment") | .metadata.name')`{{exec}}

#### Components

Let's check if Karmada successfully parsed the `spec.components` array to match the configuration we described in Step 7:

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get resourcebinding $BINDING_NAME -n default -o json | jq '.spec.components'`{{exec}}

This outputs the components array, confirming Karmada correctly extracted both the `jobmanager` and `taskmanager` components with their expected replicas and resource requests (JobManager: 0.01 CPU and 1Mi memory, TaskManager: 0.02 CPU and 2Mi memory).

#### Scheduling Result

Check that the workload was successfully scheduled by the Karmada control plane:

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get resourcebinding $BINDING_NAME -n default -o json | jq '.status.conditions[] | select(.type=="Scheduled") | .status'`{{exec}}

This outputs `"True"`, indicating the workload was successfully scheduled.

Finally, let's look at the `spec.clusters` array to confirm it was assigned to a single cluster, honoring our `maxGroups: 1` constraint from Step 7:

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get resourcebinding $BINDING_NAME -n default -o json | jq '.spec.clusters'`{{exec}}

This outputs an array with exactly one target cluster.

Verify that the FlinkDeployment exists on the target cluster using `karmadactl`:

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get flinkdeployment --operation-scope members`{{exec}}

This lists the `flinkdeployment-sample` resource, verifying it was successfully dispatched and exists on the target member cluster.
