variable "name" {
  default = "k8s-to-hcp"
}

variable "region" {
  default = "us-west1"
}

variable "tags" {
  default = {
    Environment = "hcp-vault"
  }
}