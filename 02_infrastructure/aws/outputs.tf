output "vpc_id" {
  value = "${module.cycloid_vpc.vpc}"
}

output "alb_dns" {
  value = "${module.cycloid_alb.alb_dns}"
}

output "alb_arn" {
  value = "${module.cycloid_alb.alb_arn}"
}

output "alb_listener_arn" {
  value = "${module.cycloid_alb.alb_listener_arn}"
}

output "rds_address" {
  value = "${module.cycloid_rds.rds_address}"
}

output "rds_endpoint" {
  value = "${module.cycloid_rds.rds_endpoint}"
}

output "rds_name" {
  value = "${module.cycloid_rds.rds_name}"
}

output "rds_port" {
  value = "${module.cycloid_rds.rds_port}"
}

output "ecs_cluster_id" {
  value = "${module.cycloid_ecs.ecs_cluster_id}"
}

output "ecs_service_role_default_arn" {
  value = "${module.cycloid_ecs.ecs_service_role_default_arn}"
}
