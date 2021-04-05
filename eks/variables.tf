variable "name" {
  default = "k8s-to-hcp"
}

variable "region" {
  default = "us-west-2"
}

variable "hcp_consul_cidr_block" {
  default = "172.25.16.0/20"
}

variable "tags" {
  default = {
    Environment = "hcp-vault"
  }
}

variable "additional_tags" {
  default = {
    ExtraTag = "hcp-vault"
  }
}