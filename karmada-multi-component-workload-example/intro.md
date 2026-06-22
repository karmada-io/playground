# What is Karmada?

Karmada (Kubernetes Armada) is a Kubernetes management system that enables you to run your cloud-native applications across multiple Kubernetes clusters and clouds, with no changes to your applications. By speaking Kubernetes-native APIs and providing advanced scheduling capabilities, Karmada enables truly open, multi-cloud Kubernetes.

Karmada aims to provide turnkey automation for multi-cluster application management in multi-cloud and hybrid cloud scenarios, with key features such as centralized multi-cloud management, high availability, failure recovery, and traffic scheduling.

# What is Multi-Component Workload Scheduling?

Many advanced applications are not just simple, identical replicas of a single container. They consist of multiple, tightly-coupled components with distinct resource profiles (for example, Apache Flink requires a coordinating `JobManager` and several worker `TaskManager`s, and Volcano AI batch jobs require `ParameterServer` and `Worker` nodes). 

If a multi-cluster scheduler treats these complex jobs as a single generic workload, it may underestimate the total resources required, or accidentally scatter the tightly-coupled components across entirely different geographical clusters, destroying the low-latency communication required for the job to function.

In this scenario, we will deploy a FlinkDeployment and use a dedicated PropagationPolicy to atomically propagate this multi-component workload to a member cluster with sufficient resources.
