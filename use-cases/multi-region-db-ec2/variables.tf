variable "name" {
  type    = string
  default = "multi-region-db"
}

variable "primary_region" {
  type    = string
  default = "us-east-1"
}

variable "dr_region" {
  type    = string
  default = "us-west-2"
}

variable "primary_vpc_cidr" {
  type    = string
  default = "10.60.0.0/16"
}

variable "primary_azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "primary_public_subnets" {
  type    = list(string)
  default = ["10.60.1.0/24", "10.60.2.0/24"]
}

variable "primary_private_subnets" {
  type    = list(string)
  default = ["10.60.11.0/24", "10.60.12.0/24"]
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "db_engine_version" {
  type    = string
  default = "15.7"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_ingress_cidrs" {
  type    = list(string)
  default = ["10.60.0.0/16"]
}
