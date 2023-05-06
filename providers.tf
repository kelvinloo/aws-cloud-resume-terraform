terraform {
  backend "s3" {
    bucket         = "github-oidc-terraform-aws-tfstate"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.63.0"
    }
    
  }

}
// Default aws region 
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  //profile    = "resumeprofile"
}

// Additional provider configuration for US East 1 Certificate must be issued here for Cloudfront SSL
//provider "aws" {
  //alias      = "acm"
  //region     = "us-east-1"
  //access_key = var.aws_access_key
  //secret_key = var.aws_secret_key
  //profile    = "resumeprofile"
//}
//}

