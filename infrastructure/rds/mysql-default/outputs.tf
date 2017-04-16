
output "rds_address" {
  value = "${aws_db_instance.default.address}"
}

output "rds_endpoint" {
  value = "${aws_db_instance.default.endpoint}"
}

output "rds_name" {
  value = "${aws_db_instance.default.name}"
}

output "rds_port" {
  value = "${aws_db_instance.default.port}"
}

