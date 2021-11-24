terraform {
  required_version = ">= 0.13"
  backend "s3" {
    encrypt = true
    bucket  = "centrica-tn-codepipeline-tfstate"
    region  = "eu-west-2"
    key     = "deployment-pipeline/terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

}
provider "aws" {
  region = "eu-west-2"
}