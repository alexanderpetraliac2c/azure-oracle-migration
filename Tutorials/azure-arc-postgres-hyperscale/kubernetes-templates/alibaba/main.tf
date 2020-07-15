provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region_name}"
}

// If there is not specifying vpc_id, the module will launch a new vpc
resource "alicloud_vpc" "vpc" {
  name = "${var.vpc_name}"
  cidr_block = "192.168.0.0/16"
}

// According to the vswitch cidr blocks to launch vswitche
resource "alicloud_vswitch" "vswitches" {
  vpc_id = "${alicloud_vpc.vpc.id}"
  cidr_block = "192.168.0.0/24"
  availability_zone = "${var.vswitch_availability_zone}"
}

resource "alicloud_cs_managed_kubernetes" "k8s" {
  name = "${var.cluster_name}"
  availability_zone = "${alicloud_vswitch.vswitches.availability_zone}"
  pod_cidr = "${var.pod_cidr}"
  worker_instance_types = ["${var.node_type}"]
  worker_numbers = ["${var.node_count}"]
  install_cloud_monitor = false
  password = "${var.instance_password}"
  vswitch_ids = ["${alicloud_vswitch.vswitches.id}"]
  service_cidr = "${var.service_cidr}"
  worker_disk_size = "${var.disk_size}"
  # version can not be defined in variables.tf. Options: 1.16.6-aliyun.1|1.14.8-aliyun.1
  version = "1.16.6-aliyun.1"
  new_nat_gateway = true
  slb_internet_enabled = true
}
