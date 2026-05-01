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

module "vpc" {
  source          = "../../modules/vpc-advanced"
  name            = "${var.name}-vpc"
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  enable_nat_gateway = true
  tags            = var.tags
}

resource "aws_security_group" "msk" {
  name        = "${var.name}-msk-sg"
  description = "Security group for MSK cluster"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Zookeeper"
  }

  ingress {
    from_port   = 9092
    to_port     = 9094
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Kafka plaintext, TLS, SASL"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "msk" {
  count             = var.enable_cloudwatch_logs ? 1 : 0
  name              = "/aws/msk/${var.name}"
  retention_in_days = 7
  tags              = var.tags
}

resource "aws_msk_cluster" "this" {
  cluster_name           = var.name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.broker_count

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    client_subnets  = module.vpc.private_subnet_ids
    security_groups = [aws_security_group.msk.id]

    storage_info {
      ebs_storage_info {
        volume_size = var.broker_volume_size
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  dynamic "logging_info" {
    for_each = var.enable_cloudwatch_logs ? [1] : []
    content {
      broker_logs {
        cloudwatch_logs {
          enabled   = true
          log_group = aws_cloudwatch_log_group.msk[0].name
        }
      }
    }
  }

  tags = var.tags
}

# Optional: S3 bucket for Kafka Connect / backup
resource "aws_s3_bucket" "kafka_data" {
  count  = var.create_data_bucket ? 1 : 0
  bucket = "${var.name}-kafka-data-${data.aws_caller_identity.current.account_id}"
  tags   = var.tags
}

data "aws_caller_identity" "current" {}
