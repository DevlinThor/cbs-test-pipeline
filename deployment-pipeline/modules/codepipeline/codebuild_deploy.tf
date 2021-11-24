resource "aws_codebuild_project" "codebuild_deploy" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "codebuild_deploy"
  queued_timeout = 480
  service_role   = aws_iam_role.codebuild-role.arn
  tags           = local.common_tags

  source {
    type      = "CODEPIPELINE"
    buildspec = "deployment-pipeline/${path.module}/buildspecs/aws_deploy.yml"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"

    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  artifacts {
    type = "CODEPIPELINE"
  }

}

resource "aws_codebuild_project" "quality_assurance" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "quality_assurance"
  queued_timeout = 480
  service_role   = aws_iam_role.codebuild-role.arn
  tags           = local.common_tags

  source {
    type      = "CODEPIPELINE"
    buildspec = "deployment-pipeline/${path.module}/buildspecs/quality_assurance.yml"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"

    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  artifacts {
    type = "CODEPIPELINE"
  }

}

