terraform {
  required_version = "~>0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.35"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.region
}