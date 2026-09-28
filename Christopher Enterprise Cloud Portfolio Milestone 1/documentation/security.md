# Security Baseline

## Account controls required before deployment

- Root account protected with MFA and not used for routine work
- Named or federated administrative identity protected with MFA
- Billing alerts configured
- No long-lived AWS credentials committed to the repository
- GitHub secrets used only when CI/CD deployment is intentionally enabled

## Infrastructure controls

- Network tiers are separated by subnet and security-group policy.
- Application ingress is accepted only from the load-balancer security group.
- Security groups use explicit protocols and ports.
- Private application subnets do not receive public IPv4 addresses.
- Encryption, IAM roles, secrets storage, and logging will be added alongside compute services.

## Repository controls

The `.gitignore` excludes Terraform state, variable files, keys, environment files, and local working data. Before every push:

```bash
git status
git diff --cached
```

Never store AWS access keys, passwords, account identifiers, customer data, or Terraform state in the public repository.

## Threats to test later

- Direct access attempt against a private application instance
- Excessive IAM permissions
- Public object-storage exposure
- Secret accidentally printed in a pipeline log
- Unpatched container image
- Unauthorized deployment attempt
- Denial-of-service and resource-exhaustion behavior
