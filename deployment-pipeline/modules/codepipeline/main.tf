locals {
  # Common tags to be assigned to all resources

  common_tags = {
    Environment     = terraform.workspace
    "Cost Code ID"  = "BG2000S757"
    "Service Name"  = "AWS Cloud Network"
    "Service Owner" = "Matt Ford"
    "Service Type"  = "NetworkServices Terraform Deployment"
  }
}

resource "aws_s3_bucket" "codepipeline_artifacts_s3" {
  bucket = var.codepipeline_artifacts_s3_name
  acl    = "private"

  tags = merge(local.common_tags, { "Name" = var.artifacts_s3_name_tag })
}

resource "aws_codepipeline" "networkservices-codepipeline" {
  name     = "networkservices-codepipeline"
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
        FullRepositoryId     = "CentricaDevOps/centrica-tn"
        ConnectionArn        = "arn:aws:codestar-connections:eu-west-2:267067931954:connection/a6216994-6004-4a75-a06e-08b7cd9f6656"
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

  stage {
    name = "Staging"

    dynamic "action" {
      for_each = var.customer_accounts.aws

      iterator = account
      content {
        category        = "Build"
        name            = "aws-${account.value.name}@${account.value.region}"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["source_output"]
        version         = "1"
        run_order       = account.value.run_order

        configuration = {
          ProjectName   = aws_codebuild_project.codebuild_deploy.name
          PrimarySource = "source_output"
          EnvironmentVariables = jsonencode([
            {
              name  = "ENVIRONMENT_NAME"
              value = account.value.name
            },
            {
              name  = "CONFIG"
              value = account.value.config
            },
            {
              name  = "BOOTSTRAP_DIRECTORY"
              value = account.value.bootstrap_config
            },
            {
              name  = "ROLE_ARN"
              value = var.pipeline_staging_arn

            },
            {
              name  = "AWS_REGION"
              value = account.value.region
            },
            {
              name  = "STAGING"
              value = "true"
            },
          ])
        }
      }
    }

  }


  stage {
    name = "Production"

    dynamic "action" {
      # Exclude DevTest NetworkServices as it is already deployed in staging
      for_each = [for customer in var.customer_accounts.aws : customer if customer["id"] != "469693223682"]
      iterator = account
      content {
        category        = "Build"
        name            = "aws-${account.value.name}@${account.value.region}"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["source_output"]
        version         = "1"
        run_order       = account.value.run_order

        configuration = {
          ProjectName   = aws_codebuild_project.codebuild_deploy.name
          PrimarySource = "source_output"
          EnvironmentVariables = jsonencode([
            {
              name  = "ENVIRONMENT_NAME"
              value = account.value.name
            },
            {
              name  = "CONFIG"
              value = account.value.config
            },
            {
              name  = "BOOTSTRAP_DIRECTORY"
              value = account.value.bootstrap_config
            },
            {
              name  = "ROLE_ARN"
              value = account.value.role_arn
            },
            {
              name  = "AWS_REGION"
              value = account.value.region
            },
            {
              name  = "STAGING"
              value = "false"
            },
          ])
        }
      }
    }

    dynamic "action" {
      for_each = var.centrica_tn_accounts.aws
      iterator = account
      content {
        category        = "Build"
        name            = "aws-${account.value.name}@${account.value.region}"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["pr_monitor", "source_output"]
        version         = "1"
        run_order       = account.value.run_order

        configuration = {
          ProjectName   = aws_codebuild_project.codebuild_deploy.name
          PrimarySource = "source_output"
          EnvironmentVariables = jsonencode([
            {
              name  = "ENVIRONMENT_NAME"
              value = account.value.name
            },
            {
              name  = "CONFIG"
              value = account.value.config
            },
            {
              name  = "BOOTSTRAP_DIRECTORY"
              value = account.value.bootstrap_config
            },
            {
              name  = "ROLE_ARN"
              value = account.value.role_arn

            },
            {
              name  = "AWS_REGION"
              value = account.value.region
            },
            {
              name  = "STAGING"
              value = "false"
            },
          ])
        }
      }
    }

  }
}


