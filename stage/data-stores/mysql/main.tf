provider "aws" {
  region = "eu-central-1"
  alias  = "primary"

  default_tags {
    tags = {
      ManagedBy = "terraform"
      Env       = "stage"
      Project   = "multirep"
    }
  }
}

module "database" {
  source = "github.com/savak1990/test-multirep-deployment-data?ref=v0.0.4"

  db_identifier_prefix = "vklovan-terraform-stage-"
  db_name              = "StageTerraformExample"
  db_username          = var.db_username
  db_password          = var.db_password
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
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "vklovan-terraform-up-and-running-locks"
    encrypt        = true
  }
}
