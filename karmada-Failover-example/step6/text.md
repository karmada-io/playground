### Enable Failover and Eviction feature gates

Karmada enables failover behavior through feature gates on the controller manager. Enable them now before simulating failure.

1. To ensure the single-node Kind cluster has enough resources during the update, change the deployment strategy to `Recreate` (this kills the old pod before starting the new one):

   RUN `kubectl -n karmada-system patch deployment karmada-controller-manager -p '{"spec":{"strategy":{"type":"Recreate","rollingUpdate":null}}}'`{{exec}}

2. Patch the controller manager deployment to enable the `Failover` and `GracefulEviction` feature gates, and enable taint eviction:

   RUN `kubectl -n karmada-system patch deployment karmada-controller-manager --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/command/-", "value": "--feature-gates=Failover=true,GracefulEviction=true"}, {"op": "add", "path": "/spec/template/spec/containers/0/command/-", "value": "--enable-no-execute-taint-eviction=true"}]'`{{exec}}

3. Wait for the controller manager to roll out:

   RUN `kubectl -n karmada-system rollout status deployment/karmada-controller-manager`{{exec}}

4. Verify the flag is present:

   RUN `kubectl -n karmada-system get deployment karmada-controller-manager -o jsonpath='{.spec.template.spec.containers[0].command}'`{{exec}}

