# alibaba_terraform_template

This repository holds the Terraform template for Cluster creation on Alibaba Kubernetes Service.

#### Using Terraform

User can fill all the appropriate values in terraform.tfvars and perform the below steps.

```
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

User can use this kube_config to further deployment of the resources.