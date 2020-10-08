terraform {
  required_version = "~>0.13"
  required_providers {
    aws = {
      version = "3.4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.1"
    }
  }
  backend "remote" {}
}

provider "aws" {
  region = var.region
}