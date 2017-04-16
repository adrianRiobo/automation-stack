

module "cycloid-vpc" {
  source = "./infrastructure/vpc/vpc-default"
  vpc_cidr   = "${var.vpc_cidr}"
  vpc_name = "cycloid-vpc"
}

module "cycloid-public-subnet-1" {
  source = "./infrastructure/vpc/subnet-public-nated"
  vpc_id = "${module.cycloid-vpc.vpc}"
  internet_gateway_id = "${module.cycloid-vpc.internet_gateway}"
  subnet_cidr = "${var.public_subnet1_cidr}"
  subnet_az = "${var.az_1}"
  subnet_name = "cycloid-public-subnet-1"
  
}

module "cycloid-private-subnet-1" {
  source = "./infrastructure/vpc/subnet-private-nated"
  vpc_id = "${module.cycloid-vpc.vpc}"
  nat_gateway_id = "${module.cycloid-public-subnet-1.nat_gateway}"
  subnet_cidr = "${var.private_subnet1_cidr}"
  subnet_az = "${var.az_1}"
  subnet_name = "cycloid-private-subnet-1"
}

module "cycloid-public-subnet-2" {
  source = "./infrastructure/vpc/subnet-public-nated"
  vpc_id = "${module.cycloid-vpc.vpc}"
  internet_gateway_id = "${module.cycloid-vpc.internet_gateway}"
  subnet_cidr = "${var.public_subnet2_cidr}"
  subnet_az = "${var.az_2}"
  subnet_name = "cycloid-public-subnet-2"
  
}

module "cycloid-private-subnet-2" {
  source = "./infrastructure/vpc/subnet-private-nated"
  vpc_id = "${module.cycloid-vpc.vpc}"
  nat_gateway_id = "${module.cycloid-public-subnet-2.nat_gateway}"
  subnet_cidr = "${var.private_subnet2_cidr}"
  subnet_az = "${var.az_2}"
  subnet_name = "cycloid-private-subnet-2"
}

module "cycloid-alb" {
  source = "./infrastructure/loadbalancer/alb-default"
  alb_name = "cycloid-alb"
  subnets = ["${module.cycloid-public-subnet-1.public_subnet}", "${module.cycloid-public-subnet-2.public_subnet}"]
  vpc_id = "${module.cycloid-vpc.vpc}"
}

module "cycloid-rds" {
  source = "./infrastructure/rds/mysql-default"
  rds_name = "cycloid-rds"
  subnets = ["${module.cycloid-public-subnet-1.public_subnet}", "${module.cycloid-public-subnet-2.public_subnet}"]
  vpc_id = "${module.cycloid-vpc.vpc}"
  database_name = "wordpress"
  database_password = "wordpress"
  database_username = "wordpress"
}