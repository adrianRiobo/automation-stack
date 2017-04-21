
variable "alb_name" {
    description = "Name for ALB"
}

variable "subnets" {
    description = "Name for ALB"
    type = "list"
}

variable "vpc_id" {
    description = "Id for VPC"
}

variable "vpc_default_security_group_id" {
    description = "Id for default security group in VPC"
}

resource "aws_security_group" "allow_all" {
  name        = "${var.alb_name}"
  description = "Allow all http traffic in port 80"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a load balancer
resource "aws_alb" "default" {
  name            = "${var.alb_name}"
  internal        = false
  subnets         = ["${var.subnets}"]
  security_groups = ["${aws_security_group.allow_all.id}", "${var.vpc_default_security_group_id}"]
  enable_deletion_protection = false
  tags {
    Name = "${var.alb_name}"
  }
}

#Create default target group
resource "aws_alb_target_group" "default" {
  name     = "${var.alb_name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb_listener" "default" {
  load_balancer_arn = "${aws_alb.default.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type             = "forward"
  }
}