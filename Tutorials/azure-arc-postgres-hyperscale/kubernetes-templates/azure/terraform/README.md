# azure_terraform_template

Using Terraform template for Cluster creation on Azure Kubernetes Service.

#### Using Terraform

User can fill all the appropriate values in terraform.tfvars and perform the below steps.

```
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
$ terraform output kube_config
```

User can use this kube_config to further deployment of the resources.