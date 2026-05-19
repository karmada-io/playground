# Verify Member Cluster Readiness

Before joining clusters to Karmada, confirm that the kubeconfig files were correctly copied to the controlplane node.

**Verify member1 context:**

RUN `kubectl --kubeconfig=$HOME/.kube/config-member1 config get-contexts kind-member1`{{exec}}

This validates that the member1 cluster context is correctly configured.

**Verify member2 context:**

RUN `kubectl --kubeconfig=$HOME/.kube/config-member2 config get-contexts kind-member2`{{exec}}

This validates that the member2 cluster context is correctly configured.

At this point the member cluster kubeconfigs are ready for Karmada join operations.
