variable "aws_region" {}

variable "ec2_instance_type" {
  default = "t2.small"
}

variable "resource_tags" {
  type = "map"
}