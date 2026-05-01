variable "name" {
  type        = string
  default     = "kafka-msk"
  description = "Base name for all resources"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.70.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.70.1.0/24", "10.70.2.0/24", "10.70.3.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.70.11.0/24", "10.70.12.0/24", "10.70.13.0/24"]
}

variable "kafka_version" {
  type        = string
  default     = "3.6.0"
  description = "Kafka version for MSK"
}

variable "broker_count" {
  type        = number
  default     = 3
  description = "Number of Kafka broker nodes (must be multiple of AZ count)"
}

variable "broker_instance_type" {
  type        = string
  default     = "kafka.m5.large"
  description = "MSK broker instance type"
}

variable "broker_volume_size" {
  type        = number
  default     = 100
  description = "EBS volume size per broker (GB)"
}

variable "enable_cloudwatch_logs" {
  type        = bool
  default     = true
  description = "Enable CloudWatch logging for MSK"
}

variable "create_data_bucket" {
  type        = bool
  default     = false
  description = "Create S3 bucket for Kafka data/Connect"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Project     = "kafka-msk"
  }
}
