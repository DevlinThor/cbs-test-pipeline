resource "aws_iam_role" "codepipeline-role" {
  name = "TandN-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline-policy" {
  name   = "codepipeline-policy"
  role   = aws_iam_role.codepipeline-role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_artifacts_s3.arn}",
        "${aws_s3_bucket.codepipeline_artifacts_s3.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codestar-connections:GetHost",
        "codestar-connections:GetInstallationUrl",
        "codestar-connections:GetConnection",
        "codestar-connections:ListConnections",
        "codestar-connections:GetIndividualAccessToken",
        "codestar-connections:ListTagsForResource",
        "codestar-connections:ListInstallationTargets",
        "codestar-connections:UseConnection",
        "codestar-connections:StartOAuthHandshake",
        "codestar-connections:ListHosts",
        "codestar-connections:StartAppRegistrationHandshake",
        "codestar-connections:RegisterAppCode",
        "codestar-connections:PassConnection"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "codebuild-role" {
  name = "TandN-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}



resource "aws_iam_role_policy" "crossaccount-policy" {
  name   = "TandN-CrossAccount"
  role   = aws_iam_role.codebuild-role.name
  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "sts:AssumeRole"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
      ]
      
    }
    EOF
}


resource "aws_iam_role_policy_attachment" "codebuild-access" {
  role = aws_iam_role.codebuild-role.name
  for_each = toset([
    "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  ])

  policy_arn = each.value
}
