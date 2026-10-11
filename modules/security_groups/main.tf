# Web tier: HTTP and HTTPS from anywhere
resource "aws_security_group" "web" {
  description = "Allow HTTP and HTTPS from the internet"
  name        = "${var.name}-web-sg"

  vpc_id = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-web-sg"
  }
}

# App tier: only accepts traffic from the web tier security group
resource "aws_security_group" "app" {
  description = "Allow application traffic from web tier only"
  name        = "${var.name}-app-sg"

  vpc_id = var.vpc_id

  ingress {
    description     = "App port from web tier"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-app-sg"
  }
}

# Database tier: only accepts traffic from the app tier security group
resource "aws_security_group" "db" {
  description = "Allow database traffic from app only"
  name        = "${var.name}-db-sg"

  vpc_id = var.vpc_id

  ingress  {
    description     = "db port from app tier"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  tags = {
    Name = "${var.name}-db-sg"
  }
}