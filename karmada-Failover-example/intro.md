# What is Karmada?

Karmada (Kubernetes Armada) is a Kubernetes management system that enables you to run your cloud-native applications across multiple Kubernetes clusters and clouds, with no changes to your applications. By speaking Kubernetes-native APIs and providing advanced scheduling capabilities, Karmada enables truly open, multi-cloud Kubernetes.

Karmada aims to provide turnkey automation for multi-cluster application management in multi-cloud and hybrid cloud scenarios, with key features such as centralized multi-cloud management, high availability, failure recovery, and traffic scheduling.

In this scenario, we will learn how to achieve failover in Karmada by simulating faults using taints.

# Multiple Cluster Failover through Karmada

This scenario will guide you through hands-on experience with Karmada's cluster-level failover capability in the Killercoda environment. By manually tainting a member cluster to simulate faults, you will observe how Karmada automatically migrates application workloads from the faulty cluster to a healthy one.

More information can be found in the official documentation: [Cluster Failover](https://karmada.io/docs/userguide/failover/cluster-failover).
