
variable "cluster_name" {
    description = "Name for the cluster"
}

variable "ecs_name" {
    description = "Name for ecs resources"
}

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
  name               = "ecs-instance-role"
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
    description = "Default policy for ecs instances"
    policy      = "${data.aws_iam_policy_document.ecs_instance_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_policy_attach" {
    role       = "${aws_iam_role.ecs_instance_role.name}"
    policy_arn = "${aws_iam_policy.ecs_instance_policy.arn}"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name  = "ecs-instance-prof"
  role = "${aws_iam_role.ecs_instance_role.name}"
}

data "aws_iam_policy_document" "ecs_service_assume_role_policy_document" {
  statement {
    actions = [ "sts:AssumeRole" ]

    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs-service-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service_assume_role_policy_document.json}"
}

data "aws_iam_policy_document" "ecs_service_policy_document" {
  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:RegisterTargets"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_service_policy" {
    name        = "ecs-service-policy"
    description = "Default policy for ecs services"
    policy      = "${data.aws_iam_policy_document.ecs_service_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_service_policy_attach" {
    role       = "${aws_iam_role.ecs_service_role.name}"
    policy_arn = "${aws_iam_policy.ecs_service_policy.arn}"
}