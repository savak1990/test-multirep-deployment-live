provider "aws" {
  region = "eu-central-1"

  assume_role {
    role_arn = "arn:aws:iam::474668381860:role/OrganizationAccountAccessRole"
  }

  default_tags {
    tags = {
      ManagedBy = "terraform"
      Env       = "prod"
      Project   = "multirep"
    }
  }
}

locals {
  db_remote_state_bucket = "vklovan-terraform-up-and-running-state"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = local.db_remote_state_bucket
    key    = local.db_remote_state_key
    region = "eu-central-1"
  }
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name  = "scale_out_during_business_hours"
  autoscaling_group_name = module.webserver_cluster.asg_name

  min_size         = 2
  max_size         = 10
  desired_capacity = 10
  recurrence       = "0 9 * * *"
}

resource "aws_autoscaling_schedule" "sclae_in_at_night" {
  scheduled_action_name  = "scale_in_at_night"
  autoscaling_group_name = module.webserver_cluster.asg_name
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 17 * * *"
}

module "webserver_cluster" {
  source = "github.com/savak1990/test-multirep-deployment-webserver?ref=v0.0.10"

  server_text = "Merry Christmas"

  cluster_name = "webservers-prod"

  db_address = data.terraform_remote_state.db.outputs.primary_address
  db_port    = data.terraform_remote_state.db.outputs.primary_port

  instance_type = "t2.micro"
  min_size      = 3
  max_size      = 5
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "vklovan-terraform-up-and-running-state"
    key            = "prod/services/webserver-cluster/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "vklovan-terraform-up-and-running-locks"
    encrypt        = true
  }
}
