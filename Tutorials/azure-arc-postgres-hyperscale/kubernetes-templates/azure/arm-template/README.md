# azure_resource_manager_template

Using ARM template for Cluster creation on Azure Kubernetes Service.

#### Using ARM template

User can fill all the appropriate values in parameters.json and perform the below steps.

```
az login
az deployment group create --resource-group <resource-group-name> --template-file template.json
```
