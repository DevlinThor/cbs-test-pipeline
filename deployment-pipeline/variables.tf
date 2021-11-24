variable "codepipeline_tfstate_s3_name" {
  description = "S3 Bucket for storing codepiline terraform state"
  default     = "centrica-tn-codepipeline-tfstate"
}
