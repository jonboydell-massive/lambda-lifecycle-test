data "template_file" "userdata" {
  template = "${file("${path.module}/user_data/echo_chamber.tpl")}"

  vars {
    region = "${var.aws_region}"
  }
}

data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_security_group" "instance_sg" {
  name = "instance_sg"
  ingress {
    from_port = 80
    protocol = "TCP"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol    = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${var.resource_tags}"
}

resource "aws_instance" "target" {
  ami = "${data.aws_ami.amazon_linux_ecs.id}"
  instance_type = "${var.ec2_instance_type}"
  user_data = "${data.template_file.userdata.rendered}"
  vpc_security_group_ids = ["${aws_security_group.instance_sg.id}"]

  tags = "${var.resource_tags}"
}

output "echo_chamber_host_name" {
  value = "${aws_instance.target.public_dns}"
}
