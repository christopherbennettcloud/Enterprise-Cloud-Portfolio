# Enterprise Cloud Portfolio

An enterprise cloud architecture and engineering portfolio demonstrating how business requirements become secure, repeatable, and observable cloud infrastructure.

## Project 1: Resilient Logistics Platform

The fictional client is a growing logistics company replacing a manually operated reservation platform. The target architecture must support secure online transactions, survive common infrastructure failures, and provide a future path to hybrid-cloud and disaster-recovery capabilities.

This repository deliberately separates two views:

- **Enterprise target state:** the complete architecture recommended for production.
- **Portfolio implementation:** the smaller environment actually deployed and tested at lab scale.

That separation keeps the project technically honest while demonstrating enterprise-level reasoning.

## Current milestone

Milestone 1 creates the AWS network foundation with Terraform:

- One VPC
- Two Availability Zones
- Two public subnets
- Two private application subnets
- Separate public and private route tables
- Internet gateway for the public tier
- Security groups for a future load balancer and application tier
- No NAT Gateway, database, load balancer, or compute resources yet
- Automated Terraform formatting and validation in GitHub Actions

## Planned capabilities

1. Containerized application behind an Application Load Balancer
2. Auto Scaling across two Availability Zones
3. IAM roles, encryption, and secrets management
4. CloudWatch logs, metrics, dashboards, and alarms
5. GitHub Actions CI/CD
6. Load testing and controlled failure injection
7. Recovery runbooks and measured RTO/RPO results
8. Local private-cloud simulation using Docker
9. Kafka, Cassandra, HAProxy, Prometheus, and Grafana extension
10. Hybrid-cloud and disaster-recovery target design

## Repository map

```text
.
├── architecture/
│   └── architecture.md
├── documentation/
│   ├── build-journal.md
│   ├── business-requirements.md
│   ├── cost-guardrails.md
│   ├── nonfunctional-requirements.md
│   └── security.md
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars.example
│   ├── variables.tf
│   └── versions.tf
└── .github/workflows/
    └── terraform-check.yml
```

## Safe deployment workflow

Do not deploy until AWS MFA, billing alerts, and non-root access are configured.

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform fmt -check -recursive
terraform init
terraform validate
terraform plan
terraform apply
```

After collecting evidence, remove the lab environment:

```bash
terraform destroy
```

## Interview story

This project is designed to answer four questions clearly:

1. What business problem was being solved?
2. Why was this architecture selected?
3. How was it implemented, secured, monitored, and tested?
4. What happened when a component failed?

## Status

Milestone 1 scaffold completed September 28, 2026. Cloud deployment has not yet been performed.
