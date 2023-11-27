provider "aws" {
  region = "eu-central-1"
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale_out_during_business_hours"
  autoscaling_group_name = module.webserver_cluster.asg_name

  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 9 * * *"
}

resource "aws_autoscaling_schedule" "sclae_in_at_night" {
  scheduled_action_name = "scale_in_at_night"
  autoscaling_group_name = module.webserver_cluster.asg_name
  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 17 * * *"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name = "webservers-prod"
  db_remote_state_bucket = "vklovan-terraform-up-and-running-state"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size = 3
  max_size = 5
}

terraform {
  backend "s3" {
    bucket = "vklovan-terraform-up-and-running-state"
    key = "prod/services/webserver-cluster/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "vklovan-terraform-up-and-running-locks"
    encrypt = true
  }
}
