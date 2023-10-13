terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "region" {
  type = string
  description = "The AWS region where the resources will be created"
}

provider "aws" {
  region = var.region
}

module "remote_state" {
  source = "nozaq/remote-state-s3-backend/aws"

  s3_bucket_name = "aubin-tf-backend"
  override_s3_bucket_name = true
  override_iam_policy_name = true
  iam_policy_name = "aubin-tf-s3-backend"
  override_iam_role_name = true
  iam_role_name = "aubin-tf-s3-backend"
  override_terraform_iam_policy_name = true
  terraform_iam_policy_name = "aubin-tf-s3-backend"
  dynamodb_table_name = "aubin-tf-state-lock"
  enable_replication = false
  tags = {
    CreatedBy = "aubin"
    Project = "Terraform S3 backend with DynamoDB for state lock"
  }

  providers = {
    aws         = aws
    aws.replica = aws
  }
}

resource "aws_iam_user" "terraform" {
  name = "TerraformUser"
}

resource "aws_iam_user_policy_attachment" "remote_state_access" {
  user       = aws_iam_user.terraform.name
  policy_arn = module.remote_state.terraform_iam_policy.arn
}