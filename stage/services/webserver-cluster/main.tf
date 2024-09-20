provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      ManagedBy = "terraform"
      Env       = "stage"
      Project   = "multirep"
    }
  }
}

locals {
  db_remote_state_bucket = "vklovan-terraform-up-and-running-state"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = local.db_remote_state_bucket
    key    = local.db_remote_state_key
    region = "eu-central-1"
  }
}

module "webserver_cluster" {
  source = "github.com/savak1990/test-multirep-deployment-webserver?ref=v0.0.10"

  server_text = "Merry Christmas"

  cluster_name = "webservers-stage"

  db_address = data.terraform_remote_state.db.outputs.db_address
  db_port    = data.terraform_remote_state.db.outputs.db_port

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

terraform {
  backend "s3" {
    bucket         = "vklovan-terraform-up-and-running-state"
    key            = "stage/services/webserver-cluster/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "vklovan-terraform-up-and-running-locks"
    encrypt        = true
  }
}
