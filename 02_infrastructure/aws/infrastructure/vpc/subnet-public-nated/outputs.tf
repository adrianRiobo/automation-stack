
output "public_subnet" {
  value = "${aws_subnet.default.id}"
}

output "nat_gateway" {
  value = "${aws_nat_gateway.default.id}"
}

