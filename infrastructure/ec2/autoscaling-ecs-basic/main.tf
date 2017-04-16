
variable "rds_name" {
    description = "Name for rds instance"
}

variable "subnets" {
    description = "Subnets for rds instance"
    type = "list"
}

variable "vpc_id" {
    description = "Id for VPC"
}

variable "database_name" {
    description = "Name for database"
}

variable "database_password" {
    description = "Password for database"
}

variable "database_username" {
    description = "User for database"
}

resource "aws_db_subnet_group" "default" {
  name        = "${var.rds_name}"
  subnet_ids  = ["${var.subnets}"]
  tags {
    Name = "${var.rds_name}"
  }
}

resource "aws_security_group" "default" {
  vpc_id = "${var.vpc_id}"
  tags {
    Name = "${var.rds_name}"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage          = 5
  engine                     = "mysql"
  engine_version             = "5.6.27"
  instance_class             = "db.t2.micro"
  name                       = "${var.database_name}"
  password                   = "${var.database_password}"
  username                   = "${var.database_username}"
  multi_az                   = "false"
  vpc_security_group_ids     = ["${aws_security_group.default.id}"]
  db_subnet_group_name       = "${aws_db_subnet_group.default}"
  tags {
    Name        = "${var.project}"
  }
}
