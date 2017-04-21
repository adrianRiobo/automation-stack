output "alb_dns" {
  value = "${module.cycloid_alb.alb_dns}"
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
