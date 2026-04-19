# AWS Terraform Use Cases

Production-style templates demonstrating common deployment patterns.

## 1) Multi-AZ EC2 (`use-cases/multi-az-ec2`)

Deploys:
- VPC + subnets (via shared module)
- Internet gateway + public route table
- EC2 instances spread across multiple AZs

### Usage
```bash
cd use-cases/multi-az-ec2
terraform init
terraform apply \
  -var 'ami_id=ami-xxxxxxxx' \
  -var 'key_name=my-keypair'
```

---

## 2) Multi-Region DB + EC2 foundation (`use-cases/multi-region-db-ec2`)

Deploys:
- Primary-region VPC (multi-AZ)
- Multi-AZ RDS PostgreSQL primary instance
- Cross-region read replica (DR region)

### Usage
```bash
cd use-cases/multi-region-db-ec2
terraform init
terraform apply \
  -var 'db_username=appuser' \
  -var 'db_password=SuperSecretPassword123!'
```

> Note: Cross-region replication requires valid region/provider setup, supported engine/version, and network/security hardening for production.
