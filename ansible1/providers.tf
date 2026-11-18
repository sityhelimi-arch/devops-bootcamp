terraform {
  required_version = ">= 1.5.0"
  required_providers {
aws = {
  source  = "hashicorp/aws"
  version = "~> 6.0"
}
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.9"
    }
  }

  backend "s3" {
    bucket       = "bootcamp-2026-sity"
    key          = "ansible1/terraform.tfstate"
    region       = "ap-southeast-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
}