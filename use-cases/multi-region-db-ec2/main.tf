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
  region = var.primary_region
}

provider "aws" {
  alias  = "dr"
  region = var.dr_region
}

# Primary region network + app hosts (multi-AZ)
module "primary_vpc" {
  source          = "../../modules/vpc"
  name            = "${var.name}-primary"
  vpc_cidr        = var.primary_vpc_cidr
  public_subnets  = var.primary_public_subnets
  private_subnets = var.primary_private_subnets
  azs             = var.primary_azs
}

resource "aws_db_subnet_group" "primary" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = module.primary_vpc.private_subnet_ids
}

resource "aws_security_group" "db" {
  name   = "${var.name}-db-sg"
  vpc_id = module.primary_vpc.this_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.db_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "primary" {
  identifier             = "${var.name}-primary"
  engine                 = "postgres"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.primary.name
  vpc_security_group_ids = [aws_security_group.db.id]
  multi_az               = true
  skip_final_snapshot    = true
  backup_retention_period = 7
  publicly_accessible    = false
}

# DR region read replica (cross-region)
resource "aws_db_instance" "dr_replica" {
  provider                    = aws.dr
  identifier                  = "${var.name}-dr-replica"
  replicate_source_db         = aws_db_instance.primary.arn
  instance_class              = var.db_instance_class
  skip_final_snapshot         = true
  publicly_accessible         = false
  auto_minor_version_upgrade  = true
  depends_on                  = [aws_db_instance.primary]
}

output "primary_db_endpoint" {
  value = aws_db_instance.primary.address
}

output "dr_db_endpoint" {
  value = aws_db_instance.dr_replica.address
}
