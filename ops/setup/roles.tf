variable "function_name" {}

resource "aws_iam_role" "lambda-role" {
  name = "${var.function_name}-role"
  path = "/service-role/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
}

resource "aws_iam_role_policy_attachment" "service-router-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = "${aws_iam_role.lambda-role.name}"
}

output "role-arn" {
  value = "${aws_iam_role.lambda-role.arn}"
}