# Scenario: Create an Azure Database for PostgreSQL Hyperscale server group on Azure Arc

This document describes the steps to deploy a PostgreSQL Hyperscale server group on Azure Arc.

## Login to the Azure Arc data controller

Before you can create an instance you must first login to the Azure Arc data controller if you are not already logged in.

```terminal
azdata login
```

You will then be prompted for the username, password and the system namespace.  

> If you used the script to install the data controller then your namespace should be **arc**

```terminal
Namespace: arc
Username: arcadmin
Password:
Logged in successfully to `https://10.0.0.4:30080` in namespace `arc`. Setting active context to `arc`
```

## Create a PostgreSQL Hyperscale server group

### For all users

To create a PostgreSQL Hyperscale server group on Azure Arc, use the following command:

```terminal
azdata postgres server create -n <name> -ns <namespace> -w 2 --dataSizeMb 1024 --serviceType <NodePort or LoadBalancer> --subscription <subscription ID> --rg <resource group name>

#Example
#azdata postgres server create -n postgres01 -ns default -w 2 --dataSizeMb 1024 --serviceType NodePort --subscription 182c901a-129a-4f5d-85e4-cc6b294590a2 --rg myresourcegroup
```

> **Note: Names must be 10 characters or fewer in length and conform to DNS naming conventions**

> **Note: Namespace must not be reserved namespaces**

|   Parameter Name   | Definition | Notes |
| - | - | - |
| `-n` | Name of PostgreSQL server group. **Required.** | Maximum of 12 characters |
| `--subscription` | Azure subscription ID **Required.** | Make sure your Azure subscription has been approved for the preview.  Contact your PM Buddy for approval or request approval in the preview  Teams channel. |
| `-r` | Azure resource group name **Required.** | Specify the name of the Azure resource group you want to have the resource created in. |
| `--dataSizeMb` | Size of data volumes in MB. **Required.** | Recommended to use at least 1GB (1024 MB) |
| `--serviceType` | Choose how PostgreSQL service is accessed through Kubernetes networking interface. **Required.** | `ClusterIP` - use this if you want the PostgreSQL instance to be accessible only within the Kubernetes cluster using an _internal_ IP address. <br/> `LoadBalancer` - use this if your Kubernetes cluster is deployed into an environment like AKS that supports load balancers. <br/> `NodePort` - use this if you want the PostgreSQL instance to be accessible outside the Kubernetes cluster when there is no load balancer.  Each instance will have a distinct port assigned on the Kubernetes master node to connect to. |
| `-ns` | Name of Kubernetes namespace | If not specified, deployment will go to "default" namespace.  Default = "default". |
| `-w` | Number of PostgreSQL Hyperscale worker nodes | Recommended 2 workers. Don't specify the parameter for a single-node deployment.  Default = 0. |

> **Note:** There are other command-line parameters available.  See the complete list of options by running `azdata postgres server create -h`.

### Predictable deployment experience

Resource requests will be validated against the resources available in the Kubernetes cluster.  If there are insufficient resources available, a warning will be shown indicating the insufficient resource.  
The argument --validateOnly can also be used to validate the create request, but not actually create the Azure Database for PostgreSQL Hyperscale server group.

### Notes on storage & volume provisioning

If your Kubernetes cluster has a volume provisioner such as on AKS and most other cloud environments, Kubernetes persistent volumes to store data and/or backups will be created automatically.

If your Kubernetes cluster does not have a volume provisioner configured, you'll either need [set up a volume provisioner](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/) or to manually create the volumes. If you use the script to deploy the Kubernetes cluster and the Azure Arc data controller at the same time, the volumes will be created for you automatically.

## View PostgreSQL Hyperscale server groups on Azure Arc

To view the PostgreSQL Hyperscale server groups on Azure Arc, use the following command:

```terminal
azdata postgres server list
```

```terminal
ID                                ClusterIP             ExternalIP      MustRestart    Name        Status
--------------------------------  --------------------  --------------  -------------  ----------  --------
abcdefghijklmnopqrstuvwxyz123456  10.102.204.135:30655  10.0.0.4:30655  False          postgres01  Running
```

You can then use the ExternalIP and port number when connecting.

If you are using an Azure VM to test, follow the following instructions.

## Special note about Azure virtual machine deployments

If you are using an Azure virtual machine, then the endpoint IP address will not show the _public_ IP address. To locate the public IP address, use the following command:

```terminal
az network public-ip list -g azurearcvm-rg --query "[].{PublicIP:ipAddress}" -o table
```

You can then combine the public IP address with the port to make your connection.

You may also need to expose the port of the PostgreSQL instance through the network security gateway (NSG). To allow traffic through the (NSG) you will need to add a rule which you can do using the following command.

To set a rule you will need to know the name of your NSG which you can find out using the command below:

```terminal
az network nsg list -g azurearcvm-rg --query "[].{NSGName:name}" -o table
```

Once you have the name of the NSG, you can add a firewall rule using the following command. The example values here create an NSG rule for port 30655 and allows connection from **any** source IP address.  This is not a security best practice!  You can lock things down better by specifying a -source-address-prefixes value that is specific to your client IP address or an IP address range that covers your team's or organization's IP addresses.

Replace the value of the --destination-port-ranges parameter below with the port number you got from the 'azdata postgres server list' command above.

```terminal
az network nsg rule create -n db_port --destination-port-ranges 30655 --source-address-prefixes '*' --nsg-name azurearcvmNSG --priority 500 -g azurearcvm-rg --access Allow --description 'Allow port through for db access' --destination-address-prefixes '*' --direction Inbound --protocol Tcp --source-port-ranges '*'
```

## Connect with Azure Data Studio

Open Azure Data Studio and connect to your instance with the external endpoint IP address and port number above, and the password retrieved from the `azdata postgres server endpoint` command.

Remember if you are using an Azure VM you will need the _public_ IP address which is accessible via the following command:

```terminal
az network public-ip list -g azurearcvm-rg --query "[].{PublicIP:ipAddress}" -o table
```

If PostgreSQL isn't available in the *Connection type* dropdown, you can install it by searching for PostgreSQL in the extensions tab.

## Connect with psql

To access your PostgreSQL Hyperscale server group, run `azdata postgres server endpoint` and pass the name of the PostgreSQL Hyperscale server group that you provided when you created the instance as the -n parameter value:

```terminal
azdata postgres server endpoint -n postgres01 -ns default
```

```output
Description           Endpoint
--------------------  ----------------------------------------------------------------------------------------------------------------
Log Search Dashboard  https://10.0.0.4:31777/kibana/app/kibana#/discover?_a=(query:(language:kuery,query:'cluster_name:"pg1"'))
Metrics Dashboard     https://10.0.0.4:31777/grafana/d/postgres-metrics?var-Namespace=default&var-Name=pg1
PostgreSQL Instance   postgresql://postgres:PASSWORD@10.0.0.4:30655
```

The command will output URLs that can be used to access the PostgreSQL instance, its metrics, and its logs. The PostgreSQL URL has the format `postgres://userName:password@host:port`. You can extract the host, port, and login from the URL if your PostgreSQL client application can't accept the connection string in URL form. The default database name is the same as the initial user (`postgres`).

You can now connect either with psql (install the `postgresql-client` package to use psql on an Azure VM):

```terminal
psql postgresql://postgres:PASSWORD@10.0.0.4:30655
```

For example:

| Setting         | Example value     | Notes                                                        |
| --------------- | ----------------- | ------------------------------------------------------------ |
| Server name     | `52.229.9.30`     | When using an Azure VM make sure to use the Public IP here   |
| Port            | `30655`           | **!** This needs to be entered in **"Advanced..." => "Server" => "Port"** in the connection panel, then click OK to save |
| User name       | `postgres`        | Default user is always named `postgres`                      |
| Password        | `PASSWORD`        | Retrieve the Postgres user password from `azdata postgres server endpoint` as described above |

Once connected, you can utilize the full functionality of PostgreSQL Hyperscale, including [creating distributed tables](https://docs.microsoft.com/en-us/azure/postgresql/quickstart-create-hyperscale-portal#create-and-distribute-tables).

## NOTE

- Please note that creating Azure SQL Managed Instance will not register resources in Azure. As part of Step 007 upload-grafana-kibana and 021 view billing data in azure you will be abling to see your resources in Azure portal.

