output "alb" {
  value = "${aws_alb.default.id}"
}

output "alb_dns" {
  value = "${aws_alb.default.dns_name}"
}

output "alb_arn" {
  value = "${aws_alb.default.arn}"
}

output "alb_listener_arn" {
  value = "${aws_alb_listener.default.arn}"
}