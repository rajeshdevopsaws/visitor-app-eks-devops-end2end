variable "region" {
  default     = "ap-southeast-1"
  description = "AWS region"
}
provider "aws" {
  region = var.region
}

# Setting Up Remote State

terraform {
   backend "s3" {
    dynamodb_table = "visitor-state-lock-dynamo"
    bucket = "visitor-terraform-state-bucket"
    key    = "sit-terraform.tfstate"
    region = "ap-southeast-1"
  }
  required_version = ">= 1.0.0"
}