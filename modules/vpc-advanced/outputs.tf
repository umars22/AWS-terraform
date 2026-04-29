output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "Public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "Private subnet IDs"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.this.id
  description = "IGW ID"
}

output "nat_gateway_id" {
  value       = var.enable_nat_gateway ? aws_nat_gateway.this[0].id : null
  description = "NAT Gateway ID if enabled"
}
