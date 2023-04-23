### create deployment

display current nginxDeployment.yaml file and propagationPolicy.yaml file

RUN ` cat ~/nginx/nginxDeployment.yaml`{{exec}}

RUN ` cat ~/nginx/propagationPolicy.yaml`{{exec}}

create deployment named nginx

   RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f ~/nginx/nginxDeployment.yaml`{{exec}}

   RUN `kubectl --kubeconfig /etc/karmada/karmada-apiserver.config apply -f ~/nginx/propagationPolicy.yaml`{{exec}}

check deployments and pods

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get deployment `{{exec}}

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get pods `{{exec}}
