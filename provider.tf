terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-2"
  access_key = "AKIA3NH5DBCE4HJPQ353"
  secret_key = "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"
}
