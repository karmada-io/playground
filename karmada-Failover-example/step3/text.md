### Simulate taint

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config taint cluster kind-member2 failover-test=:NoExecute`{{exec}}
