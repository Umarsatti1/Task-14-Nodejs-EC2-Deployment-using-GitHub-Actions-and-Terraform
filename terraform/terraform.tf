terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
  }

  backend "s3" {
    bucket       = "umarsatti-terraform-state-file-s3-bucket-sandbox"
    key          = "Task-14-GitHub-Actions/terraform.tfstate"
    region       = "us-west-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-west-1"
}