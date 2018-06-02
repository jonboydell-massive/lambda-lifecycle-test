module "echo_chamber" {
  source = "./echo_chamber"
  aws_region = "us-east-1"
  providers = {
    aws = "aws.use1"
  }
  resource_tags = {
    Owner = "${var.owner_email}"
    Project = "${var.project_name}"
  }
}