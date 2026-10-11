variable "name" {
  type        = string
  description = "Name prefix for resources"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPCs the security groups belong to"
}

variable "app_port" {
  type        = number
  description = "port that the app listens on"
}

variable "db_port" {
  type        = number
  description = "port that the db listens on"
}

