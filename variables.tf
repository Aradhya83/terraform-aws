variable "aws_region" {
  type        = string
  description = "Region for AWS to deploy into"
  default     = "ap-south-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile name. Optional, can be set to null to get default cred. chain"
  default     = null
}

variable "project_name" {
  type        = string
  description = "Name prefix, to be applied to all resources"
  default     = null
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR block for private subnets (one per availability zone)"
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR block for public subnets (one per availability zone)"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_port" {
  type        = number
  description = "port the application listens on"
  default     = 8080
}

variable "db_port" {
  type        = number
  description = "port that the db listens on"
  default     = 5432
}

variable "az_count" {
  type        = number
  description = "number of availability zones to spread the subnets across"
  default     = 2
}


