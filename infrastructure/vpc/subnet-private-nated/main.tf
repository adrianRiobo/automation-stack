
variable "vpc_id" {
    description = "Id for VPC"
}

variable "nat_gateway_id" {
    description = "Id for Nat Gateway"
}

variable "subnet_cidr" {
    description = "CIDR for the subnet"
}

variable "subnet_az" {
    description = "Az for subnet"
}

variable "subnet_name" {
    description = "Subnet name"
}

/*
  Private Subnet 
*/
resource "aws_subnet" "default" {
    vpc_id = "${var.vpc_id}"
    cidr_block = "${var.subnet_cidr}"
    availability_zone = "${var.subnet_az}"
    tags {
        Name = "${var.subnet_name}"
    }
}

/*
  Routing table for private subnet 
*/
resource "aws_route_table" "default" {
    vpc_id = "${var.vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${var.nat_gateway_id}"
    }

    tags {
        Name = "${var.subnet_name}"
    }
}

resource "aws_route_table_association" "default" {
    subnet_id = "${aws_subnet.default.id}"
    route_table_id = "${aws_route_table.default.id}"
}



