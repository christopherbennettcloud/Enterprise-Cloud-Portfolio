# Business Requirements

## Client scenario

A growing logistics company currently manages commercial vehicle parking reservations through disconnected manual processes. It needs a secure platform for customer reservations, availability management, payments integration, notifications, and operational reporting.

## Business outcomes

- Allow customers to view availability and create reservations at any time.
- Reduce manual processing and reservation errors.
- Support expansion from one location to a nationwide network.
- Maintain customer access during common infrastructure failures.
- Provide auditable security and operational records.
- Avoid unnecessary dependence on a single proprietary service where portability creates measurable value.
- Control early-stage operating costs without preventing future scale.

## Stakeholders

- Customers and fleet partners
- Site operations
- Customer support
- Finance and payment-processing teams
- Security and compliance
- Application and platform engineering
- Executive leadership

## Constraints

- Portfolio implementation must remain inexpensive and short-lived.
- No real customer, payment, or personally identifiable information may be used.
- The first implementation uses synthetic traffic and test data.
- Expensive enterprise products may appear in the target design only when their purpose and affordable lab substitute are documented.
- All deployed infrastructure must be reproducible and removable through code.

## Success criteria

- Infrastructure deploys from version-controlled Terraform.
- Application traffic is distributed across at least two failure domains.
- Unauthorized network paths are blocked by default.
- A failed application component is detected and recovered.
- Deployment and recovery procedures can be followed by another engineer.
- Actual recovery results are compared with the target RTO and RPO.
- The complete lab can be destroyed without leaving chargeable resources behind.
