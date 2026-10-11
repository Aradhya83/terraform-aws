output "vpc_id" {
  description = "ID of VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "ID of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "ID of private subnets"
  value       = module.vpc.private_subnet_ids
}

output "app_sg_id" {
  description = "ID of application security group"
  value       = module.security_groups.app_sg_id
}

output "web_sg_id" {
  description = "ID of web security group"
  value       = module.security_groups.web_sg_id
}

output "db_sg_id" {
  description = "ID of db security group"
  value       = module.security_groups.db_sg_id
}