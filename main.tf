data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

module "vpc" {
  source = "./modules/vpc"

  name                 = var.project_name
  region               = var.aws_region
  vpc_cidr             = var.vpc_cidr
  azs                  = local.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}


module "security_groups" {
  source = "./modules/security_groups"

  name     = var.project_name
  vpc_id   = module.vpc.vpc_id
  app_port = var.app_port
  db_port  = var.db_port
}



# optional test instance to check the internet gateway , route table and web security group work (disabled by default)

data "aws_ami" "amazon_linux" {
  count       = var.create_test_instance ? 1 : 0
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
     name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "test" {
  count = var.create_test_instance ? 1 : 0

  ami                         = data.aws_ami.amazon_linux[0].id
  instance_type               = var.test_instance_type
  subnet_id                   = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids      = [module.security_groups.web_sg_id]
  associate_public_ip_address = true

  user_data_replace_on_change = true
  user_data                   = <<-EOT
        #!/bin/bash
        mkdir -p /var/www/html
        echo "<h1>Hello from the VPC</h1>" > /var/www/html/index.html
        cd /var/www/html
        setsid nohup python3 -m http.server 80 > /var/log/http-server.log 2>&1 &
    EOT  

  metadata_options {
    http_tokens = "required" # require IMDSv2
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = {
    Name = "${var.project_name}-test-instance"
  }
}

