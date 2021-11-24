
variable "codepipeline_name_tag" {
  type        = string
  description = "Name tag for codepipeline"
  default     = "lab-codepipeline"
}

variable "artifacts_s3_name_tag" {
  type        = string
  description = "Name tag for codepipeline"
  default     = "codepipeline-artifacts-s3"
}

variable "codepipeline_artifacts_s3_name" {
  type        = string
  description = "S3 Bucket for storing artifacts"
  default     = "codepipe-artifacts-1"
}

/*

variable "region" {
  description = "AWS region"
  default     = "eu-west-2"
}

variable "repo_branch" {
  description = "Repository branch to connect to"
  default     = "master"
}

variable "repo_owner" {
  description = "GitHub repository owner"
  default     = "CentricaDevOps"
}

variable "repo_name" {
  description = "GitHub repository name"
  default     = "centrica-tn"
}

variable "github_token" {
  type        = string
  description = "Github private access token"
}

variable "pipeline_staging_arn" {
  description = "Role ARN for Staging in pipeline"
  type        = string
  default     = "arn:aws:iam::469693223682:role/Terraform-Build-Role"

}

variable "customer_accounts" {
  type = object({
    aws = list(object({
      name             = string,
      id               = string,
      role_arn         = string,
      config           = string,
      bootstrap_config = string,
      region           = string,
      run_order        = number
    }))
  })
}

variable "centrica_tn_accounts" {
  type = object({
    aws = list(object({
      name             = string,
      id               = string,
      role_arn         = string,
      config           = string,
      bootstrap_config = string,
      region           = string,
      run_order        = number
    }))
  })
}
*/