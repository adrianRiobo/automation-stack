resource "aws_vpc" "cycloid-vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "cycloid-vpc"
    }
}

resource "aws_internet_gateway" "cycloid-vpc-igw" {
    vpc_id = "${aws_vpc.default.id}"
}

/*
  Public Subnet 1
*/
resource "aws_subnet" "cycloid-public-subnet-1" {
    vpc_id = "${aws_vpc.cycloid-vpc.id}"
    cidr_block = "${var.public_subnet1_cidr}"
    availability_zone = "eu-west-1a"
    tags {
        Name = "Public Subnet 1"
    }
}

/*
  Public Subnet 2
*/
resource "aws_subnet" "cycloid-public-subnet-2" {
    vpc_id = "${aws_vpc.cycloid-vpc.id}"
    cidr_block = "${var.public_subnet2_cidr}"
    availability_zone = "eu-west-1b"
    tags {
        Name = "Public Subnet 2"
    }
}

/*
  Private Subnet 1
*/
resource "aws_subnet" "cycloid-private-subnet-1" {
    vpc_id = "${aws_vpc.cycloid-vpc.id}"
    cidr_block = "${var.private_subnet1_cidr}"
    availability_zone = "eu-west-1a"
    tags {
        Name = "Private Subnet 1"
    }
}

/*
  Private Subnet 2
*/
resource "aws_subnet" "cycloid-private-subnet-2" {
    vpc_id = "${aws_vpc.cycloid-vpc.id}"
    cidr_block = "${var.private_subnet2_cidr}"
    availability_zone = "eu-west-1b"
    tags {
        Name = "Private Subnet 2"
    }
}

/*
  Nat Configuration for public subnet 1
*/
resource "aws_eip" "cycloid-public-subnet-1-nat-eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.cycloid-vpc-igw"]
}

resource "aws_nat_gateway" "cycloid-public-subnet-1-natgw" {
  allocation_id = "${aws_eip.cycloid-public-subnet-1-nat-eip.id}"
  subnet_id     = "${aws_subnet.cycloid-public-subnet-1.id}"
}

/*
  Nat Configuration for public subnet 2
*/
resource "aws_eip" "cycloid-public-subnet-2-nat-eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.cycloid-vpc-igw"]
}

resource "aws_nat_gateway" "cycloid-public-subnet-2-natgw" {
  allocation_id = "${aws_eip.cycloid-public-subnet-2-nat-eip.id}"
  subnet_id     = "${aws_subnet.cycloid-public-subnet-2.id}"
}

/*
  Routing table for public subnet 1
*/
resource "aws_route_table" "cycloid-public-subnet-1" {
    vpc_id = "${aws_vpc.cycloid-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.cycloid-vpc-igw.id}"
    }

    tags {
        Name = "Public Subnet 1"
    }
}

resource "aws_route_table_association" "cycloid-public-subnet-1" {
    subnet_id = "${aws_subnet.cycloid-public-subnet-1.id}"
    route_table_id = "${aws_route_table.cycloid-public-subnet-1.id}"
}

/*
  Routing table for public subnet 2
*/
resource "aws_route_table" "cycloid-public-subnet-2" {
    vpc_id = "${aws_vpc.cycloid-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.cycloid-vpc-igw.id}"
    }

    tags {
        Name = "Public Subnet 2"
    }
}

resource "aws_route_table_association" "cycloid-public-subnet-2" {
    subnet_id = "${aws_subnet.cycloid-public-subnet-2.id}"
    route_table_id = "${aws_route_table.cycloid-public-subnet-2.id}"
}

/*
  Routing table for private subnet 1
*/
resource "aws_route_table" "cycloid-private-subnet-1" {
    vpc_id = "${aws_vpc.cycloid-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.cycloid-public-subnet-1-natgw.id}"
    }

    tags {
        Name = "Private Subnet 1"
    }
}

resource "aws_route_table_association" "cycloid-private-subnet-1" {
    subnet_id = "${aws_subnet.cycloid-private-subnet-1.id}"
    route_table_id = "${aws_route_table.cycloid-private-subnet-1.id}"
}

/*
  Routing table for private subnet 2
*/
resource "aws_route_table" "cycloid-private-subnet-2" {
    vpc_id = "${aws_vpc.cycloid-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.cycloid-public-subnet-2-natgw.id}"
    }

    tags {
        Name = "Private Subnet 2"
    }
}

resource "aws_route_table_association" "cycloid-private-subnet-2" {
    subnet_id = "${aws_subnet.cycloid-private-subnet-2.id}"
    route_table_id = "${aws_route_table.cycloid-private-subnet-2.id}"
}


