terraform {
  required_version = "~>0.13"
  required_providers {
    google = {
      version = "~> 3.43.0"
    }
    google-beta = {
      version = "~> 3.43.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13.1"
    }
  }
  backend "remote" {}
}

provider "google" {}
provider "google-beta" {}