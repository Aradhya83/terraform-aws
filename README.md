# terraform-aws

A three-tier AWS network built with Terraform modules: a VPC with public and private subnets across two availability zones, an internet gateway, route tables, and tiered security groups. 

## This demonstrates
- Infrastructure as Code on AWS with Terraform
- Reusable Terraform modules (`vpc`, `security_groups`) with inputs and outputs
- Network design: public vs. private subnets, route tables, internet gateway, S3 gateway endpoint
- Security groups that chain by reference (web → app → db) instead of open CIDR ranges

## Architecture
```
                     Internet
                        │
                ┌───────┴────────┐
                │ Internet GW    │
                └───────┬────────┘
     ┌──────────────────┴───────────────────────┐
     │ VPC 10.0.0.0/16                          │
     │                                          │
     │  Public subnets (10.0.1.0/24, 10.0.2.0/24)
     │   route: 0.0.0.0/0 → Internet GW         │
     │   [web-sg: 80, 443 from anywhere]        │
     │                                          │
     │  Private subnets (10.0.11.0/24, 10.0.12.0/24)
     │   route: local only + S3 gateway endpoint│
     │   [app-sg: app port from web-sg]         │
     │   [db-sg:  db port from app-sg]          │
     └──────────────────────────────────────────┘
```

## Resources created
| Resource | Purpose |
|---|---|
| VPC (`10.0.0.0/16`) | Isolated network with DNS support |
| 2 public subnets | One per AZ, public IPs assigned on launch |
| 2 private subnets | One per AZ, no route to the internet |
| Internet gateway + public route table | Default route to the internet for public subnets |
| Private route table | Local traffic only |
| S3 gateway endpoint | Free private access to S3 from private subnets |
| `web`, `app`, `db` security groups | Tiered access: internet → web → app → db |
| EC2 test instance (optional) | Checks the public path end to end |


## Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/install) 1.5 or newer
- An AWS account and the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured (`aws configure`, or an AWS profile). 

## Usage
```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Show the outputs:
```bash
terraform output
```
### Test the public path (optional)
Set `create_test_instance = true` in `terraform.tfvars` and apply again. The instance runs a tiny web server in a public subnet. Open the `test_url` output in a browser (or `curl` it). Because the web security group allows port 80, you should see the test page. The app and db security groups only accept traffic from the tier in front of them, so they are not reachable from the internet.

### Clean up
```bash
terraform destroy
```
After destroying, check the VPC and EC2 consoles for leftover resources.

## Project structure
```
aws-vpc-terraform/
├── providers.tf             # Terraform and provider configuration
├── main.tf                  # Modules, optional test instance
├── variables.tf             # Input variables
├── outputs.tf               # Output values
├── terraform.tfvars.example # Example variable values
├── modules/
│   ├── vpc/                 # VPC, subnets, gateway, route tables, S3 endpoint
│   └── security_groups/     # web, app and db security groups
└── .github/workflows/
    └── terraform.yml        # fmt, init and validate on every push
```

## Variables
| Name | Default | Description |
|---|---|---|
| `aws_region` | `ap-south-1` | Region to deploy into |
| `aws_profile` | `null` | Optional AWS CLI profile |
| `project_name` | `vpc-demo` | Name prefix for all resources |
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR block |
| `az_count` | `2` | Number of availability zones |
| `public_subnet_cidrs` | `["10.0.1.0/24", "10.0.2.0/24"]` | One CIDR per AZ |
| `private_subnet_cidrs` | `["10.0.11.0/24", "10.0.12.0/24"]` | One CIDR per AZ |
| `app_port` | `8080` | App tier port |
| `db_port` | `5432` | Database tier port |
| `create_test_instance` | `false` | Create the optional EC2 test instance |
| `test_instance_type` | `t3.micro` | Test instance type |

The number of entries in each subnet CIDR list must match `az_count`.

## Design decisions
- **No NAT gateway:** the private subnets have no internet route, which keeps the project free. The S3 gateway endpoint covers private access to S3.
- **Security group chaining:** the app group accepts traffic only from the web group, and the db group only from the app group.
- **Database outbound:** the db group has no egress rules, so it cannot start outbound connections. Security groups are stateful, so replies to allowed inbound traffic still work.



