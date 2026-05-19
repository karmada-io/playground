# Environment Overview

The environment consists of two hosts:

1. `controlplane`: The host Kubernetes cluster where Karmada runs. The kubeconfig files for the host cluster are located in the `$HOME/.kube` directory.
2. `node01`: Used to create member clusters.

| HostName | Host IP |
| --- | --- |
| controlplane | 172.30.1.2 |
| node01 | 172.30.2.2 |

Note: The current terminal is on the host controlplane.
