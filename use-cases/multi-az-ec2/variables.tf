variable "name" {
  type    = string
  default = "multi-az-ec2"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.50.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.50.1.0/24", "10.50.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.50.11.0/24", "10.50.12.0/24"]
}

variable "ami_id" {
  type        = string
  description = "AMI for EC2 instances"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name"
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "ssh_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "app_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
