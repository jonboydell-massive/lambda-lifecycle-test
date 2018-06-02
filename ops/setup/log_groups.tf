resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/us-east-1.${var.function_name}"

  tags {
    Owner = "${var.owner_email}"
  }
}