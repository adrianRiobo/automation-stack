variable "ecr_name" {
    description = "Name for the registry"
}

resource "aws_ecr_repository" "default" {
  name = "${var.ecr_name}"
}
