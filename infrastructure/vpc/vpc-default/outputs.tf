output "vpc" {
  value = "${aws_vpc.default.id}"
}

output "internet_gateway" {
  value = "${aws_internet_gateway.default.id}"
}

output "vpc_default_security_group_id" {
  value = "${aws_security_group.default.id}"
}