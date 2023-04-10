### join member clusters（kind-member1 and kind-member2）to host cluster

1. join member clusters（kind-member1 and kind-member2）to host cluster

   RUN `MEMBER_CLUSTER_NAME=kind-member1`{{exec}}

   RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config  join ${MEMBER_CLUSTER_NAME} --cluster-kubeconfig=$HOME/.kube/config-member1 --cluster-context=kind-member1`{{exec}}

   RUN `MEMBER_CLUSTER_NAME=kind-member2`{{exec}}

   RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config  join ${MEMBER_CLUSTER_NAME} --cluster-kubeconfig=$HOME/.kube/config-member2 --cluster-context=kind-member2`{{exec}}
2. check karmada resources

   RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config get clusters`{{exec}}
3. The following example is output, indicating that the addition was successful

   ![Scan results](../image/success.png)
