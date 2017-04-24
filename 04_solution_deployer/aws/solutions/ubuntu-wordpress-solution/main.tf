
variable "db_host" {
    description = "Host for db"
}

variable "db_port" {
    description = "Port for db"
}

variable "db_user" {
    description = "User for db"
}

variable "db_password" {
    description = "Password for db"
}

variable "db_database" {
    description = "Database name"
}

variable "cluster_id" {
    description = "Cluster id where to deploy the solution"
}

variable "vpc_id" {
    description = "VPC id"
}

variable "alb_listener_arn" {
    description = "ALB arn"
}

variable "ecs_service_role_default_arn" {
    description = "Default role for service in ecs"
}

#https://github.com/hashicorp/terraform/issues/11907
#data "template_file" "ubuntu_wordpress_task_definition" {
#  template = "${file("${path.module}/templates/ubuntu-wordpress-task-definition.tpl")}"
#  vars {
#    db_host = "${var.db_host}"
#    db_port = "${var.db_port}"
#    db_user = "${var.db_user}"
#    db_password = "${var.db_password}"
#    db_database = "${var.db_database}"
#  }
#}

#container_definitions = "${data.template_file.ubuntu_wordpress_task_definition.rendered}"
resource "aws_ecs_task_definition" "ubuntu_wordpress_task_definition" {
  family = "wordpress-service"
  container_definitions = "${file("${path.module}/templates/ubuntu-wordpress-task-definition.json")}"
}

resource "aws_ecs_service" "ubuntu_wordpress_service" {
  name          = "ubuntu-wordpress-service"
  cluster       = "${var.cluster_id}"
  desired_count = 1
  task_definition = "${aws_ecs_task_definition.ubuntu_wordpress_task_definition.arn}"
  iam_role        = "${var.ecs_service_role_default_arn}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ubuntu_wordpress_target_group.arn}"
    container_name   = "wordpress-ubuntu"
    container_port   = "80"
  }

  depends_on = ["aws_ecs_task_definition.ubuntu_wordpress_task_definition", "aws_alb_target_group.ubuntu_wordpress_target_group"]
}

#Create default target group
resource "aws_alb_target_group" "ubuntu_wordpress_target_group" {
  name     = "ubuntu-wordpress-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    interval = "30"
    path   = "/"
    healthy_threshold = 2
    matcher = "200-302"
  }
}

resource "aws_alb_listener_rule" "ubuntu_wordpress_listener_rule" {
  listener_arn = "${var.alb_listener_arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.ubuntu_wordpress_target_group.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/*"]
  }
}
