terraform {
  backend "s3" {
    bucket         = "github-oidc-terraform-aws-tfstate"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
  }
}