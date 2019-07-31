provider "aws" {
  region  = "us-west-2"
  version = "~> 2.21"
  profile = "personal"
}

terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket  = "luhn-terraform"
    profile = "personal"
    key     = "luhn.com.json"
    region  = "us-west-2"
  }
}

data "aws_caller_identity" "main" {
}

data "aws_region" "current" {
}

