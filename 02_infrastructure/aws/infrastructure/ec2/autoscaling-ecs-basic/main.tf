
variable "autoscaling_name" {
    description = "Name of the autoscaling"
}

variable "cluster_name" {
    description = "Name of the cluster"
}

variable "ami" {
    description = "ami"
}

variable "vpc_default_security_group_id" {
    description = "Id for default security group in VPC"
}

variable "key_name" {
    description = "key for user in instance"
}

variable "ecs_instance_profile_id" {
    description = "Id for default instance profile"
}

variable "subnets" {
    description = "Subnets where autoscaling will be setted"
    type = "list"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/basic-ecs-instance.tpl")}"
  vars {
    cluster_name = "${var.cluster_name}"
  }
}

resource "aws_launch_configuration" "ecs_launch_configuration" {
  name = "${var.autoscaling_name}"
  image_id = "${var.ami}"
  instance_type = "t2.micro"
  security_groups = ["${var.vpc_default_security_group_id}"]
  associate_public_ip_address = false
  ebs_optimized = false
  key_name = "${var.key_name}"
  iam_instance_profile = "${var.ecs_instance_profile_id}"
  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                 = "${var.autoscaling_name}"
  launch_configuration = "${aws_launch_configuration.ecs_launch_configuration.name}"
  min_size             = 0
  desired_capacity     = 1
  max_size             = 30
  vpc_zone_identifier = ["${var.subnets}"]

  lifecycle {
    create_before_destroy = true
  }
}