
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


variable "subnets" {
    description = "Subnets for rds instance"
    type = "list"
}

variable "database_name" {
    description = "Name for database"
}

variable "database_password" {
    description = "Password for database"
}

variable "database_username" {
    description = "User for database"
}

variable "vpc_default_security_group_id" {
    description = "Id for default security group in VPC"
}

resource "template_file" "user_data" {
  template = "./../templates/basic-ecs-instance.tpl"
  vars {
    cluster_name = "${var.cluster_name}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "collaborator" {
  name = "${var.autoscaling_name}"
  image_id = "${var.ami}"
  instance_type = "t2.micro"
  security_groups = ["${var.vpc_default_security_group_id}"]
  associate_public_ip_address = false
  ebs_optimized = false
  key_name = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.iam_profile.id}"
  user_data = "${template_file.user_data.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}