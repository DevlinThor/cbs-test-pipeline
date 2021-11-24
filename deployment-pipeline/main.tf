resource "aws_s3_bucket" "codepipeline_tfstate_s3" {
  bucket = var.codepipeline_tfstate_s3_name
  acl    = "private"

}


data "aws_ssm_parameter" "github_token" {
  name            = "/codepipeline/github_token"
  with_decryption = true
}

module "pipeline" {
  source                         = "./modules/codepipeline"
  github_token                   = data.aws_ssm_parameter.github_token.value
  codepipeline_artifacts_s3_name = "centrica-tn-codepipeline-artifacts"

  centrica_tn_accounts = {
    aws = [
      {
        name             = "prod-networkservices-tools"
        id               = "267067931954"
        role_arn         = "arn:aws:iam::267067931954:role/Terraform-Build-Role"
        config           = "aws/prod-networkservices-tools/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 1
      },
      {
        name             = "prod-networkservices-tools"
        id               = "267067931954"
        role_arn         = "arn:aws:iam::267067931954:role/Terraform-Build-Role"
        config           = "aws/prod-networkservices-tools/eu-west-1"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-1"
        run_order        = 1
      }
    ]
  }

  customer_accounts = {
    aws = [
      {
        name             = "devtest-networkservices-sandbox"
        id               = "469693223682"
        role_arn         = "arn:aws:iam::469693223682:role/Terraform-Build-Role"
        config           = "aws/devtest-networkservices-sandbox/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 2
      },
      {
        name             = "devtest-networkservices"
        id               = "469693223682"
        role_arn         = "arn:aws:iam::469693223682:role/Terraform-Build-Role"
        config           = "aws/devtest-networkservices/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 1
      },
      {
        name             = "devtest-networkservices"
        id               = "469693223682"
        role_arn         = "arn:aws:iam::469693223682:role/Terraform-Build-Role"
        config           = "aws/devtest-networkservices/eu-west-1"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-1"
        run_order        = 1
      },
      {
        name             = "prod-networkservices"
        id               = "267067931954"
        role_arn         = "arn:aws:iam::267067931954:role/Terraform-Build-Role"
        config           = "aws/prod-networkservices/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 2
      },
      {
        name             = "prod-security"
        id               = "329341119828"
        role_arn         = "arn:aws:iam::329341119828:role/Terraform-Build-Role"
        config           = "aws/prod-security/eu-west-1"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-1"
        run_order        = 2
      },
      {
        name             = "prod-security"
        id               = "329341119828"
        role_arn         = "arn:aws:iam::329341119828:role/Terraform-Build-Role"
        config           = "aws/prod-security/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 2
      },
      {
        name             = "devtest-centricaintegration"
        id               = "092771368131"
        role_arn         = "arn:aws:iam::092771368131:role/Mode2NetworkAdmin"
        config           = "aws/devtest-centricaintegration/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 2
      },
      {
        name             = "preprod-centricaintegration"
        id               = "071520379721"
        role_arn         = "arn:aws:iam::071520379721:role/Mode2NetworkAdmin"
        config           = "aws/preprod-centricaintegration/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 2
      },
      {
        name             = "prod-centricaintegration"
        id               = "268607150845"
        role_arn         = "arn:aws:iam::268607150845:role/Mode2NetworkAdmin"
        config           = "aws/prod-centricaintegration/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 2
      },
      {
        name             = "tools-centricaintegration"
        id               = "990305277663"
        role_arn         = "arn:aws:iam::990305277663:role/Mode2NetworkAdmin"
        config           = "aws/tools-centricaintegration/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 2
      },
      {
        name             = "devtest-maasdata"
        id               = "393498852716"
        role_arn         = "arn:aws:iam::393498852716:role/Mode2NetworkAdmin"
        config           = "aws/devtest-maasdata/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 2
      },
      {
        name             = "preprod-maasdata"
        id               = "735701274759"
        role_arn         = "arn:aws:iam::735701274759:role/Mode2NetworkAdmin"
        config           = "aws/preprod-maasdata/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 2
      },
      {
        name             = "prod-maasdata"
        id               = "355623261047"
        role_arn         = "arn:aws:iam::355623261047:role/Mode2NetworkAdmin"
        config           = "aws/prod-maasdata/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 2
      },
      {
        name             = "prod-nabuhenergy"
        id               = "283439770623"
        role_arn         = "arn:aws:iam::283439770623:role/Mode2NetworkAdmin"
        config           = "aws/prod-nabuhenergy/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 2
      },
      {
        name             = "devtest-workflowapps"
        id               = "583179794537"
        role_arn         = "arn:aws:iam::583179794537:role/Mode2NetworkAdmin"
        config           = "aws/devtest-workflowapps/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 2
      },
      {
        name             = "tools-sreactivedirectory"
        id               = "771135409204"
        role_arn         = "arn:aws:iam::771135409204:role/Mode2NetworkAdmin"
        config           = "aws/tools-sreactivedirectory/eu-west-2"
        bootstrap_config = "aws/bootstrap-terraform-backend"
        region           = "eu-west-2"
        run_order        = 2
      }
    ]
  }
}




