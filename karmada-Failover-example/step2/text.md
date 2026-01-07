### create deployment

display current nginxDeployment.yaml file and propagationPolicy.yaml file

RUN ` cat ~/nginx/nginxDeployment.yaml`{{exec}}

RUN ` cat ~/nginx/propagationPolicy.yaml`{{exec}}

create deployment named nginx

   RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f ~/nginx/nginxDeployment.yaml`{{exec}}

   RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f ~/nginx/propagationPolicy.yaml`{{exec}}

check deployments and pods and their distribution across member clusters:
- You should see that the deployment is created and pods are running on both member clusters as per the propagation policy.
- Their distribution should be: kind-member1: 2 pods, kind-member2: 1 pods.

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get deployment --operation-scope members`{{exec}}

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get pods --operation-scope members`{{exec}}
