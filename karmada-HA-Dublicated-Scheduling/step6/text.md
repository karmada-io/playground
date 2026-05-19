# Join Member Clusters

**Join `kind-member1`:**

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config join kind-member1 --cluster-kubeconfig=$HOME/.kube/config-member1 --cluster-context=kind-member1`{{exec}}

This registers the member1 cluster with the Karmada control plane for scheduling.

**Join `kind-member2`:**

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config join kind-member2 --cluster-kubeconfig=$HOME/.kube/config-member2 --cluster-context=kind-member2`{{exec}}

This registers the member2 cluster with the Karmada control plane for scheduling.

**Check joined clusters:**

RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get clusters`{{exec}}

This lists all clusters currently managed by Karmada. Both clusters should show `READY=True`.

**Note:** If a join command fails because the cluster is already registered, continue to the cluster check command.
