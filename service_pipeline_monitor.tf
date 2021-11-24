resource "aws_codebuild_project" "pipeline_monitor" {
  name         = "pipeline_monitor"
  description  = "Build the pipeline monitor service"
  service_role = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "deployment-pipeline/${path.module}/buildspecs/pipeline_monitor.yml"
  }

  tags = local.common_tags
}