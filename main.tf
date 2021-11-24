locals {
  # Common tags to be assigned to all resources

  common_tags = {
    Environment     = terraform.workspace
    "Service Owner" = "Devlin Thornicroft"
  }
}


# CREATE S3 BUCKET TO STORE CODEPIPELINE ARTIFACTS
resource "aws_s3_bucket" "codepipeline_artifacts_s3" {
  bucket = var.codepipeline_artifacts_s3_name
  acl    = "private"

  tags = merge(local.common_tags, { "Name" = var.artifacts_s3_name_tag })
}


resource "aws_codepipeline" "networkservices-codepipeline" {
  name     = "lab-codepipeline"
  role_arn = aws_iam_role.codepipeline-role.arn
  tags     = merge(local.common_tags, { "Name" = var.codepipeline_name_tag })

  artifact_store {
    location = var.codepipeline_artifacts_s3_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category         = "Source"
      name             = "Source"
      output_artifacts = ["source_output"]
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      run_order        = 1
      version          = "1"
      configuration = {
        FullRepositoryId     = "DevlinThor/test-pipeline"
        ConnectionArn        = "arn:aws:codestar-connections:eu-west-2:784362309769:connection/46e63eaf-ddb8-455a-8f18-41a1a1bfa361"
        BranchName           = "master"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "QualityAssurance"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.quality_assurance.name

      }
    }

    action {
      name             = "PipelineMonitor"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["pr_monitor"]
      version          = "1"
      run_order        = 2

      configuration = {
        ProjectName = aws_codebuild_project.pipeline_monitor.name
      }
    }

  }



}


