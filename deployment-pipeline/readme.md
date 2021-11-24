# Deployment Pipeline

This folder contains the deployment configuration for [codepipeline module](modules/codepipeline). 

See [codepipelinet module documentation](modules/codepipeline/readme.md) for more details about the pipeline

## Quick Start

1. `git clone` this repo to your computer.
2. Install [Terraform](https://www.terraform.io/).
3. cd deployment-pipeline
4. Run `terraform init`.
5. Run `terraform apply`.

## Updating the pipeline

There is an :egg: vs :chicken: problem with pipeline updates as pushing a change will trigger the old pipeline. 

**If you change the pipeline structure you will need to apply the changes manually first**, then push the code. 

Note that build specs are read from source and changes in them will get properly picked up.

## Adding an account to the pipeline

To add an account to the pipeline you need to add a config block to main.tf as follows:


```
{
    name                       = "<The account name as it will appear in the codepipeline webpage>"
    id                         = "<The account id (number)>
    role_arn                   = "<The arn to the role that will be used to setup the account>"
    config                     = "<The directory where the config lives>"
    region                     = "<The region where the account resources should be created>"
    bootstrap_config           = "aws/bootstrap-terraform-backend"
    run_order                  = 2 <pipeline config, only change if you know what you're doing>
}
```

You should run terraform apply by hand for the changes to be applied 
