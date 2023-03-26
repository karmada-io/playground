### Background：

1. The kubeconfig files for the host cluster, member1 cluster, and member2 cluster are located in the $HOME/.kube directory. These files are named config, config-member1, and config-member2 respectively.

   ```shell
      $HOME/.kube/config
      $HOME/.kube/config-member1
      $HOME/.kube/config-member2
   ```
2. Check whether the member cluster is ready

   RUN `kubectl --kubeconfig=$HOME/.kube/config-member1 config get-contexts`{{exec}}

   RUN `kubectl --kubeconfig=$HOME/.kube/config-member2 config get-contexts`{{exec}}
