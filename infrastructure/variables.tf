variable "aws_access_key" {
  description = "The AWS access key."
}

variable "aws_secret_key" {
  description = "The AWS secret key."
}

variable "region" {
  description = "The AWS region to create resources in."
  default = "eu-west-1"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.180.0.0/16"
}

variable "public_subnet1_cidr" {
    description = "CIDR for the Public Subnet 1"
    default = "10.180.8.0/21"
}

variable "public_subnet2_cidr" {
    description = "CIDR for the Public Subnet 2"
    default = "10.180.16.0/21"
}

variable "private_subnet1_cidr" {
    description = "CIDR for the Private Subnet 1"
    default = "10.180.24.0/21"
}

variable "private_subnet2_cidr" {
    description = "CIDR for the Private Subnet 2"
    default = "10.180.32.0/21"
}

