terraform {
  required_providers {
    vngcloud = {
      source  = "vngcloud/vngcloud"
      version = "1.1.3"
    }
  }
}
provider "vngcloud" {
  token_url        = "https://iamapis.vngcloud.vn/accounts-api/v2/auth/token"
  client_id        = var.client_id
  client_secret    = var.client_secret
  vserver_base_url = "https://hcm-3.api.vngcloud.vn/vserver/vserver-gateway"
  vlb_base_url = "https://hcm-3.api.vngcloud.vn/vserver/vlb-gateway"
}
resource "vngcloud_vserver_network" "network" {
    project_id = var.project_id //Thuộc Project ID
    name = "example-vpc" //Tên VPC
    cidr = "10.74.0.0/16" //Tạo VPC với CIDR 10.76.0.0/16
}
resource "vngcloud_vserver_subnet" "subnet" {
    project_id = var.project_id //Thuộc Project ID
    name = "example-subnet" //Tên subnet
    cidr = "10.74.1.0/24" //Tạo Subnet 10.76.1.0/24
    network_id = vngcloud_vserver_network.network.id //VPC ID
}
resource "vngcloud_vserver_secgroup" "secgroup" {
    project_id = var.project_id //Thuộc Project ID
    name = "example-secgroup" //Tên Security Group
}

resource "vngcloud_vserver_secgrouprule" "secgrouprule" {
    description = "allow_all" //Mô tả về rule 
    project_id = var.project_id //Thuộc Project ID
    direction ="ingress" //Inbound rule
    ethertype ="IPv4" //Ether type: IPv4
    port_range_max = 65535 //Port range 0-65535
    port_range_min = 0 //Port range 0-65535
    protocol = "any" // Protocol: Any
    remote_ip_prefix = "0.0.0.0/0" //Allow trên Range IP: 0.0.0.0/0
    security_group_id = resource.vngcloud_vserver_secgroup.secgroup.id //Security Group ID
}
