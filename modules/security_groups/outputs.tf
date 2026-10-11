output "web_sg_id" {
  description = "ID of web tier security group"
  value       = aws_security_group.web.id
}

output "app_sg_id" {
  description = "ID of app tier security group"
  value       = aws_security_group.app.id
}

output "db_sg_id" {
  description = "ID of db tier security group"
  value       = aws_security_group.db.id
}