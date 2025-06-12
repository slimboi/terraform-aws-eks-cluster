terraform {
  backend "s3" {
    bucket       = "myapp-terraform-state-1285"
    key          = "eks-cluster/terraform.tfstate"
    region       = "ap-southeast-2"
    use_lockfile = true
    encrypt      = true # Add this for security
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Optional: Set minimum Terraform version
  required_version = ">= 1.0"
}

# AWS Provider configuration
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      environment = "dev"
      application = "myapp"
      managedBy   = "terraform"
      project     = "eks-cluster"
    }
  }
}