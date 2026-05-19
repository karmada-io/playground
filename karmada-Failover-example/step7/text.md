### Create deployment

Create a deployment named `nginx`.

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f ~/nginx/nginxDeployment.yaml`{{exec}}

<details>
<summary>nginxDeployment.yaml</summary>

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx
```

</details>

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f ~/nginx/propagationPolicy.yaml`{{exec}}

<details>
<summary>propagationPolicy.yaml</summary>

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
      replicaDivisionPreference: Weighted
      replicaSchedulingType: Divided
      weightPreference:
        staticWeightList:
          - targetCluster:
              clusterNames:
                - kind-member1
            weight: 2
          - targetCluster:
              clusterNames:
                - kind-member2
            weight: 1
```

</details>

Check deployments and pods and their distribution across member clusters:

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get deployment --operation-scope members`{{exec}}

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get pods --operation-scope members`{{exec}}

- You should see that the deployment is created and pods are running on both member clusters as per the propagation policy.
- Their distribution should be: kind-member1: 2 pods, kind-member2: 1 pods.

> **Note:** If the expected output doesn't appear, wait for 30 seconds to 1 minute and try again.

