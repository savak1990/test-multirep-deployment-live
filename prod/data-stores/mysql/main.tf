provider "aws" {
  region = "eu-central-1"
  alias  = "primary"

  default_tags {
    tags = {
      ManagedBy = "terraform"
      Env       = "prod"
      Project   = "multirep"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  alias  = "replica"

  default_tags {
    tags = {
      ManagedBy = "terraform"
      Env       = "prod"
      Project   = "multirep"
    }
  }
}

module "database" {
  source = "github.com/savak1990/test-multirep-deployment-data?ref=v0.0.4"

  providers = {
    aws = aws.primary
  }

  db_identifier_prefix    = "vklovan-terraform-prod-"
  db_name                 = "ProdTerraformExample"
  db_username             = var.db_username
  db_password             = var.db_password
  backup_retention_period = 1
}

module "replica" {
  source = "github.com/savak1990/test-multirep-deployment-data?ref=v0.0.4"

  providers = {
    aws = aws.replica
  }

  db_identifier_prefix = "vklovan-terraform-prod-"
  replicate_source_db  = module.database.arn
}

terraform {
  backend "s3" {
    bucket         = "vklovan-terraform-up-and-running-state"
    key            = "prod/data-stores/mysql/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "vklovan-terraform-up-and-running-locks"
    encrypt        = true
  }
}
