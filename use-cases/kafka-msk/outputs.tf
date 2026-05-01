output "msk_cluster_arn" {
  value       = aws_msk_cluster.this.arn
  description = "MSK cluster ARN"
}

output "msk_bootstrap_brokers_tls" {
  value       = aws_msk_cluster.this.bootstrap_brokers_tls
  description = "TLS bootstrap broker endpoints"
}

output "msk_zookeeper_connect_string" {
  value       = aws_msk_cluster.this.zookeeper_connect_string
  description = "Zookeeper connection string"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "Private subnet IDs"
}

output "msk_security_group_id" {
  value       = aws_security_group.msk.id
  description = "MSK security group ID"
}

output "data_bucket_name" {
  value       = var.create_data_bucket ? aws_s3_bucket.kafka_data[0].id : null
  description = "S3 bucket name if created"
}
