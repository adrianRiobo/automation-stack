
variable "cluster_name" {
    description = "Name for the cluster"
}

variable "ecs_name" {
    description = "Name for ecs resources"
}


#For service we will get the resource in this way
#data "aws_ecs_cluster" "default" {
#  cluster_name = "${var.cluster_name}"
#}

resource "aws_ecs_cluster" "default" {
  name = "${var.cluster_name}"
}

data "aws_iam_policy_document" "ecs_assume_role_policy_document" {
  statement {
    actions = [ "sts:AssumeRole" ]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name               = "${var.ecs_name}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_assume_role_policy_document.json}"
}

data "aws_iam_policy_document" "ecs_instance_policy_document" {
  statement {
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecs:Submit*",
      "ecs:ListClusters",
      "ecs:ListContainerInstances",
      "ecs:DescribeContainerInstances",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "autoscaling:DescribeAutoScalingInstances",
      "s3:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_instance_policy" {
    name        = "ecs-instance-policy"
    description = "A test policy"
    policy      = "${data.aws_iam_policy_document.ecs_instance_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_policy_attach" {
    role       = "${aws_iam_role.ecs_instance_role.name}"
    policy_arn = "${aws_iam_policy.ecs_instance_policy.arn}"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name  = "${var.ecs_name}"
  role = "${aws_iam_role.ecs_instance_role.name}"
}
