terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Use existing reusable VPC template from this repo.
module "vpc" {
  source          = "../../modules/vpc"
  name            = var.name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

resource "aws_security_group" "ec2" {
  name        = "${var.name}-ec2-sg"
  description = "Allow SSH + app traffic"
  vpc_id      = module.vpc.this_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidrs
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = var.app_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ec2-sg"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.this_id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = module.vpc.this_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(module.vpc.public_subnet_ids)
  subnet_id      = module.vpc.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# Deploy EC2 instances across multiple AZs for HA.
resource "aws_instance" "app" {
  count                       = length(module.vpc.public_subnet_ids)
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnet_ids[count.index]
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "${var.name}-app-${count.index + 1}"
    AZ   = var.azs[count.index]
  }
}

output "instance_public_ips" {
  description = "Public IPs for each AZ-deployed EC2 instance"
  value       = aws_instance.app[*].public_ip
}
