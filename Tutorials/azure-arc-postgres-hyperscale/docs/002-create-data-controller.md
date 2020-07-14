# Scenario: Create the Azure Arc data controller

## Overview of installing the Azure Arc data controller

Azure Arc enabled data services is supported on multiple different types of Kubernetes clusters and managed Kubernetes services.  Currently the supported list of services and distributions are the following:

- Azure Kubernetes Service (AKS)
- Open source, upstream Kubernetes version 1.14+ typically deployed using kubeadm


Regardless of which target deployment platform  you choose you will be prompted for the following information:

- AZDATA_USERNAME - username of your choice
- AZDATA_PASSWORD - password of your choice (The password must be at least 8 characters long and contain characters from three of the following four sets: uppercase letters, lowercase letters, numbers, and symbols.)
- DOCKER_USERNAME - XXXXXXXXX
- DOCKER_PASSWORD - XXXXXXXXX
- Data controller name - any friendly name of your choice
- Azure subscription ID - the Azure subscription ID for where you want the data controller resource in Azure to be created
- Resource group name - the name of the resource group where you want the data controller resource in Azure to be created
- Location - the Azure location where the data controller resource will be created in Azure - enter one of the following: eastus, eastus2, centralus, westus2, westeurope, southeastasia
- Connectivity Mode - Connectivity mode of your cluster. Currently only "indirect" is supported

> **Note:** you can use a different value for the namespace (-n) parameter of the azdata arc dc create command, but be sure to use that namespace in all other commands below such as the kubectl commands

Follow the appropriate section below depending on your target platform to configure your deployment.

## Install the Azure Arc data controller

### Install on Azure Kubernetes Service (AKS)

By default the AKS deployment profile uses the 'managed-premium' storage class.  The 'managed-premium' storage class will only work if you have VMs that were deployed using VM images that have premium disks.   If you are not sure what storage class to use, you should use the 'default' storage class which is supported regardless of which VM type you are using. It just won't provide the fastest performance.

If you are going to use 'managed-premium' as your storage class, then you can run the following command to deploy the data controller:

```terminal
azdata arc dc create -c azure-arc-aks-private-preview --namespace arc --name arc --subscription <subscription id> --resource-group <resource group name> --location <location> --connectivity-mode indirect
```

If you want to use the 'default' storage class, then you need to change the storage class in your configuration profile and then start the data controller deployment by running the following commands:

```terminal
azdata arc dc config init -s azure-arc-aks-private-preview -t ./custom
azdata arc dc config replace --config-file ./custom/control.json --json-values "spec.storage.data.className=default"
azdata arc dc config replace --config-file ./custom/control.json --json-values "spec.storage.logs.className=default"
azdata arc dc create -c ./custom --namespace arc --name arc --subscription <subscription id> --resource-group <resource group name> --location <location> --connectivity-mode indirect
```

### Install on open source, upstream Kubernetes (kubeadm)

By default, the kubeadm deployment profile uses a storage class called 'local-storage' and service type 'NodePort'.  If this is acceptable you can skip the instructions below that set the desired storage class and service type and immediate run the `azdata arc dc create` command below.

If you want to customize your deployment profile to specify a specific storage class and/or service type, start by creating a new custom deployment profile file based on the kubeadm deployment profile by running the following command:

```terminal
azdata arc dc config init -s azure-arc-kubeadm-private-preview -t ./custom
```

You can look up the available storage classes by running the following command:

```terminal
kubectl get storageclass
```

Now, set the desired storage class by replacing `<storageclassname>` in the command below with the name of the storage class that you want to use that was determined by running the `kubectl get storageclass` command above.

```terminal
azdata arc dc config replace --config-file ./custom/control.json --json-values "spec.storage.data.className=<storageclassname>"
azdata arc dc config replace --config-file ./custom/control.json --json-values "spec.storage.logs.className=<storageclassname>"

#Example:
#azdata arc dc config replace --config-file ./custom/control.json --json-values "spec.storage.data.className=mystorageclass"
#azdata arc dc config replace --config-file ./custom/control.json --json-values "spec.storage.logs.className=mystorageclass"
```

By default the kubeadm deployment profile uses 'NodePort' as the service type.  **If** you are using a Kubernetes cluster that is integrated with a load balancer, you can change the configuration using the following command:

```terminal
azdata arc dc config replace --config-file ./custom/control.json --json-values "$.spec.endpoints[*].serviceType=LoadBalancer"
```

Now you are ready to install the data controller using the following command:

```terminal
azdata arc dc create -c ./custom --namespace arc --name arc --subscription <subscription id> --resource-group <resource group name> --location <location> --connectivity-mode indirect
```

## Monitoring the deployment status

Creating the controller will take a few minutes to complete. You can monitor the progress in another terminal window with the following command:

```terminal
kubectl get pods -n arc
```

You can also check on the deployment status of any particular pod by running a command like this:

```terminal
kubectl describe po/<pod name> -n arc
```

Example:

```terminal
kubectl describe po/control-2g7bl -n arc
```

## Next steps

Now try to [deploy a PostgreSQL Hyperscale server group on Kubernetes Cluster](003-create-pghsaa-instance.md)
