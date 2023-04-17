### Check the status and quantity distribution of pods and deployments

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get deployment
`{{exec}}

RUN `karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config get pods
`{{exec}}
