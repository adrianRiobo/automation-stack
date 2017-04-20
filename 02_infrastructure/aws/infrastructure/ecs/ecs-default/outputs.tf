output "ecs_instance_profile_id" {
  value = "${aws_iam_instance_profile.ecs_instance_profile.id}"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.default.id}"
}

output "ecs_service_role_default_arn" {
  value = "${aws_iam_role.ecs_service_role.arn}"
}