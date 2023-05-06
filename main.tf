terraform {
  backend "s3" {
    bucket         = "github-oidc-terraform-aws-tfstate"
    key            = "terraform.tfstate"
    region = "ap-southeast-2"
  }
  # A provider requirement consists of a local name (aws),  source location, and a version constraint. 
  required_providers {
    aws = {     
      # Declaring the source location/address where Terraform can download plugins
      source  = "hashicorp/aws"
      # Declaring the version of aws provider as greater than 3.0
      version = "~> 4.63.0"  
    }
  }
}


# Configuring the AWS Provider in us-east-1 region

provider "aws" {
  region = "ap-southeast-2"
}

provider "aws"{
  alias = "acm"
  region = "us-east-1"
}