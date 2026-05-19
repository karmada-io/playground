### Simulate cluster failure

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config taint cluster kind-member2 failover-test:NoExecute`{{exec}}

This adds a taint to the member cluster `kind-member2` to simulate a failure.
