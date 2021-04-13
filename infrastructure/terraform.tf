provider "aws" {
  region  = "us-west-2"
  profile = "personal"
}

provider "aws" {
  alias   = "east"
  region  = "us-east-1"
  profile = "personal"
}

terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.36"
    }
  }

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

