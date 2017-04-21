output "alb" {
  value = "${aws_alb.default.id}"
}

output "alb_dns" {
  value = "${aws_alb.default.dns_name}"
}