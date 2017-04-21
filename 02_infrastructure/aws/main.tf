

module "cycloid_vpc" {
  source = "./infrastructure/vpc/vpc-default"
  vpc_cidr   = "${var.vpc_cidr}"
  vpc_name = "cycloid-vpc"
}

module "cycloid_public_subnet_1" {
  source = "./infrastructure/vpc/subnet-public-nated"
  vpc_id = "${module.cycloid_vpc.vpc}"
  internet_gateway_id = "${module.cycloid_vpc.internet_gateway}"
  subnet_cidr = "${var.public_subnet1_cidr}"
  subnet_az = "${var.az_1}"
  subnet_name = "cycloid-public-subnet-1"
  
}

module "cycloid_private_subnet_1" {
  source = "./infrastructure/vpc/subnet-private-nated"
  vpc_id = "${module.cycloid_vpc.vpc}"
  nat_gateway_id = "${module.cycloid_public_subnet_1.nat_gateway}"
  subnet_cidr = "${var.private_subnet1_cidr}"
  subnet_az = "${var.az_1}"
  subnet_name = "cycloid-private-subnet-1"
}

module "cycloid_public_subnet_2" {
  source = "./infrastructure/vpc/subnet-public-nated"
  vpc_id = "${module.cycloid_vpc.vpc}"
  internet_gateway_id = "${module.cycloid_vpc.internet_gateway}"
  subnet_cidr = "${var.public_subnet2_cidr}"
  subnet_az = "${var.az_2}"
  subnet_name = "cycloid-public-subnet-2"
  
}

module "cycloid_private_subnet_2" {
  source = "./infrastructure/vpc/subnet-private-nated"
  vpc_id = "${module.cycloid_vpc.vpc}"
  nat_gateway_id = "${module.cycloid_public_subnet_2.nat_gateway}"
  subnet_cidr = "${var.private_subnet2_cidr}"
  subnet_az = "${var.az_2}"
  subnet_name = "cycloid-private-subnet-2"
}

module "cycloid_alb" {
  source = "./infrastructure/loadbalancer/alb-default"
  alb_name = "cycloid-alb"
  subnets = ["${module.cycloid_public_subnet_1.public_subnet}", "${module.cycloid_public_subnet_2.public_subnet}"]
  vpc_id = "${module.cycloid_vpc.vpc}"
  vpc_default_security_group_id = "${module.cycloid_vpc.vpc_default_security_group_id}"
}

module "cycloid_rds" {
  source = "./infrastructure/rds/mysql-default"
  rds_name = "cycloid-rds"
  subnets = ["${module.cycloid_public_subnet_1.public_subnet}", "${module.cycloid_public_subnet_2.public_subnet}"]
  vpc_default_security_group_id = "${module.cycloid_vpc.vpc_default_security_group_id}"
  database_name = "wordpress"
  database_password = "wordpress"
  database_username = "wordpress"
}

module "cycloid_ecs" {
  source = "./infrastructure/ecs/ecs-default"
  cluster_name = "cycloid-ecs"
  ecs_name = "cycloid-ecs"
}

#TODO move cluster name to variables
#TODO mechanism to select ami value by region
#TODO move key pair name to variables
module "cycloid-ecs2-autoscaling" {
  source = "./infrastructure/ec2/autoscaling-ecs-basic"
  autoscaling_name = "cycloid-autoscaling"
  cluster_name = "cycloid-ecs"
  ami = "ami-95f8d2f3"
  vpc_default_security_group_id = "${module.cycloid_vpc.vpc_default_security_group_id}"
  key_name = "cycloid-pe"
  ecs_instance_profile_id = "${module.cycloid_ecs.ecs_instance_profile_id}"
  subnets = ["${module.cycloid_private_subnet_1.private_subnet}", "${module.cycloid_private_subnet_2.private_subnet}"]
}

#TODO move ecr_name name to variables
module "cycloid-ecr-wordpress" {
  source = "./infrastructure/ecs/ecr-default"
  ecr_name = "cycloid/wordpress-ubuntu"
}
