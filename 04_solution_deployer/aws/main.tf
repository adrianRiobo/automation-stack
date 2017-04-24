
#For service we will get the resource in this way
#data "aws_ecs_cluster" "default" {
#  cluster_name = "${var.cluster_name}"
#}

module "cycloid_ubuntu_wordpress_solution" {
  source = "./solutions/ubuntu-wordpress-solution"
  db_host   = "${var.db_host}"
  db_port   = "${var.db_port}"
  db_user   = "${var.db_user}"
  db_password   = "${var.db_password}"
  db_database   = "${var.db_database}"
  cluster_id   = "${var.cluster_id}"
  vpc_id       = "${var.vpc_id}"
  alb_listener_arn   = "${var.alb_listener_arn}"
  ecs_service_role_default_arn   = "${var.ecs_service_role_default_arn}"
}