terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 4.0"
   }
 }
}

provider "aws" {
 region = "ap-southeast-2"
}

terraform {
  backend "s3" {
    bucket         = "github-oidc-terraform-aws-tfstate"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
  }
}