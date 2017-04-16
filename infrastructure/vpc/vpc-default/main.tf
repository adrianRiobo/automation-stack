
variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.180.0.0/16"
}

variable "vpc_name" {
    description = "Name for the whole VPC"
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "${var.vpc_name}"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}




