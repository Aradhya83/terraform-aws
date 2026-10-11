variable "name" {
  type        = string
  description = "name prefix for all the resources"
}

variable "region" {
  type        = string
  description = "AWS region used for S3 gateway endpoint service name"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "azs" {
  type        = list(string)
  description = "availability zones to use"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets, one per availability zone"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets, one per availability zone"
}