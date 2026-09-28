# Cost Guardrails

## Rules

1. Configure AWS billing alerts before the first deployment.
2. Review `terraform plan` before every apply.
3. Deploy chargeable resources only for a defined test window.
4. Run `terraform destroy` after testing and confirm deletion in AWS.
5. Review the AWS billing dashboard after every lab session.
6. Tag supported resources with project and environment identifiers.
7. Never assume a service is free merely because the account has free-tier eligibility or credits.

## Services intentionally excluded from Milestone 1

- NAT Gateway
- Elastic IP address
- Application Load Balancer
- EC2 instances
- RDS
- EKS
- MSK
- AWS Site-to-Site VPN

They will be introduced only when a specific test requires them and removed afterward.

## Pre-deployment checklist

- [ ] MFA enabled
- [ ] Non-root access configured
- [ ] Billing alerts confirmed
- [ ] Region confirmed
- [ ] Terraform plan saved or reviewed
- [ ] Test start and stop time recorded
- [ ] Destroy command prepared

## Post-deployment checklist

- [ ] Screenshots and test results captured
- [ ] `terraform destroy` completed
- [ ] Terraform reports zero managed resources remaining
- [ ] AWS Console checked for unexpected resources
- [ ] Billing dashboard reviewed
- [ ] Build journal updated
