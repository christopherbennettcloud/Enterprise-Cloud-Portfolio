# Build Journal

## September 28, 2026 — Milestone 1 scaffold

### Work completed

- Defined a logistics business scenario and measurable outcomes.
- Separated the enterprise target architecture from the affordable lab implementation.
- Created initial availability, recovery, security, observability, and cost requirements.
- Created Terraform for a two-Availability-Zone VPC.
- Created separate public and private route tables.
- Created security-group boundaries for a future load balancer and application tier.
- Added automated Terraform checks for GitHub pull requests and pushes.

### Architectural decision

The first milestone excludes NAT Gateway, compute, databases, and load balancing. This keeps the initial deployment inexpensive and isolates networking concepts before application components are introduced.

### Validation status

- Repository structure: completed
- Static file and secret checks: pending local validation
- Terraform formatting and validation: GitHub workflow prepared; local Terraform binary not yet installed
- AWS deployment: not performed

### What comes next

1. Secure the AWS account and configure billing alerts.
2. Install Terraform, AWS CLI, Git, Docker, and VS Code on the working computer.
3. Run Terraform format, initialization, validation, and plan.
4. Deploy the network briefly and verify it in AWS.
5. Destroy the environment and document the result.
