# AWS region and AZs in which to deploy
variable "aws_region" {
  default = "us-west-2"
}

# All resources will be tagged with this
variable "environment_name" {
  default = "hcp-vault-lambda-extension-demo"
}

# DB instance size
variable "db_instance_type" {
  default = "db.t2.micro"
}

variable "hcp_vault_addr" {
  description = "Public endpoint for HCP Vault"
}

variable "hcp_vault_namespace" {
  description = "Namespace for HCP Vault"
}

variable "hcp_vault_account" {
  description = "AWS Account ID for HCP Vault"
}