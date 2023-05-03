variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
  default     = "web-hosting-bucket-kelvin"
}

//variable "aws_access_key" {}

//variable "aws_secret_key" {}

variable "domain_name" {
  default = "www.kelvinloo.com"
}

variable "registered_domain_name" {
  default = "kelvinloo.com"
}