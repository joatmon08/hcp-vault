//--------------------------------------------------------------------
// Providers

provider "aws" {
  // Credentials set via env vars
  version = "~> 3.6.0"
  region  = var.aws_region
}