variable "aws_access_key" {
    description = "The AWS access key."
    default = ""
}

variable "aws_secret_key" {
    description = "The AWS secret key."
    default = ""
}

variable "region" {
    description = "The AWS region to create resources in."
    default = "eu-west-1"
}


variable "db_host" {
    description = "Host for db"
}

variable "db_port" {
    description = "Port for db"
}

variable "db_user" {
    description = "User for db"
}

variable "db_password" {
    description = "Password for db"
}

variable "db_database" {
    description = "Database name"
}

variable "cluster_id" {
    description = "Cluster id where to deploy the solution"
}

variable "vpc_id" {
    description = "Main id for vpc"
}

variable "alb_listener_arn" {
    description = "ALB arn"
}

variable "ecs_service_role_default_arn" {
    description = "Default role for service in ecs"
}


