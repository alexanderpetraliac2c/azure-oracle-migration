provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
  features {}
}

resource "azurerm_resource_group" "resourceGroup" {
  name = "${var.resourceGroupName}"
  location = "${var.regionName}"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name = "${var.clusterName}"
  resource_group_name = "${azurerm_resource_group.resourceGroup.name}"
  dns_prefix = "${var.clusterName}-dns"
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
    service_cidr = "10.0.0.0/16"
    dns_service_ip = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }
  service_principal {
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }
  location = "${var.regionName}"
  kubernetes_version = "1.15.10"
  default_node_pool {
    name = "default"
    node_count = "${var.node_count}"
    vm_size = "${var.node_type}"
  }
  addon_profile {

    aci_connector_linux {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }
  }
  role_based_access_control {
    enabled = false
  }
}

output "kube_config" {
  sensitive = true
  value = azurerm_kubernetes_cluster.cluster.kube_config_raw
}
