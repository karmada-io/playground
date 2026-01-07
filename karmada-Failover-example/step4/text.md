### Check the status and quantity distribution of pods

After enabling the `Failover` feature gate and the `eviction` feature, if a cluster is tainted with `NoExecute` and the `propagationPolicy` does not tolerate this taint, Karmada will evict the Pods from that cluster and reschedule them onto other healthy clusters.

Therefore, you will observe that the Pods on the `kind-member2` cluster have been evicted and rescheduled onto the `kind-member1` cluster.

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get pods --operation-scope members --watch`{{exec}}
