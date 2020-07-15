# Uninstall Azure Arc data controller

If you deployed the Azure Arc data controller on your existing Kubernetes cluster, you can uninstall it and its associated namespaces by running the following commands:

## Step 01: Delete PostgreSQL cluster
```terminal
azdata postgres server delete -n <nameSpecifiedDuringCreation> -ns <namespaceSpecifiedDuringCreation>
# for example azdata postgres server delete -n postgres01 -ns default
```


## Step 02: Delete the Azure Arc data controller components

```terminal
azdata postgres uninstall
azdata arc dc delete -ns <namespaceSpecifiedDuringCreation>
# for example azdata arc dc delete -ns arc
```

## Step 03: Optionally, delete the Azure Arc data controller namespace

```terminal
kubectl delete ns <nameSpecifiedDuringCreation>
# for example kubectl delete ns arc
```

