provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      ManagedBy = "terraform"
      Env       = "global"
      Project   = "multirep"
    }
  }
}

resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}

terraform {
  backend "s3" {
    bucket         = "vklovan-terraform-up-and-running-state"
    key            = "global/iam/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "vklovan-terraform-up-and-running-locks"
    encrypt        = true
  }
}
