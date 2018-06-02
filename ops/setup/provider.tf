variable "aws_region" {
  default =  "us-east-1"
}

provider "aws" {
  region = "${var.aws_region}"
}

provider "aws" {
  alias = "use1"
  region = "${var.aws_region}"
}