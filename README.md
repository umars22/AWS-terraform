# AWS Terraform Templates

Reusable Terraform templates for common AWS infrastructure.

## Modules
- `modules/vpc` - VPC + public/private subnets (basic)
- `modules/vpc-advanced` - production-style VPC (IGW, NAT, route tables, tagging)
- `modules/ecs-cluster` - ECS cluster
- `modules/eks-cluster` - EKS cluster skeleton
- `modules/lambda` - Lambda function + IAM role

## Environments
- `envs/dev`
- `envs/stage`
- `envs/prod`

## Use Cases
- `use-cases/multi-az-ec2` - deploy EC2 instances across multiple AZs
- `use-cases/multi-region-db-ec2` - deploy multi-AZ RDS primary + cross-region replica
- `use-cases/README.md` - usage examples and caveats
