# Architecture

## Portfolio implementation: Milestone 1

```mermaid
flowchart TB
    Internet["Internet"] --> IGW["Internet Gateway"]
    IGW --> PUB["Public route table"]
    subgraph VPC["AWS VPC — 10.20.0.0/16"]
        direction TB
        PUB --> PA["Public subnet A"]
        PUB --> PB["Public subnet B"]
        PA -. "future load balancer" .-> APP["Application security group"]
        PB -. "future load balancer" .-> APP
        APP --> PRA["Private app subnet A"]
        APP --> PRB["Private app subnet B"]
    end
```

The initial implementation establishes network segmentation without provisioning hourly billed compute or networking services. Private subnets intentionally have no default internet route during this milestone.

## Enterprise target state

```mermaid
flowchart TB
    Users["Customers and partners"] --> Edge["Cloudflare edge security"]
    Edge --> AWS["AWS production region"]
    Edge -. "disaster recovery" .-> DR["Secondary cloud/region"]
    Private["Private enterprise environment"] <-->|"encrypted hybrid connection"| AWS
    AWS --> Events["Kafka event platform"]
    Private --> Events
    Events --> Data["Distributed data services"]
    AWS --> Observe["Central monitoring and security"]
    DR --> Observe
    Private --> Observe
```

The enterprise target is a future-state design. Its vendor choices, capacity, recovery topology, and security controls will be justified through architecture decision records rather than treated as automatically necessary.

## Trust boundaries

- Public edge: untrusted customer and partner traffic
- Public AWS tier: load-balancing endpoints only
- Private application tier: no direct inbound internet access
- Data tier: reachable only by explicitly authorized application identities
- Management plane: authenticated administrative access with MFA and auditable actions
- Hybrid boundary: encrypted, authenticated communication between environments

## Failure domains to test

- Individual application process
- Individual compute instance or container
- Availability Zone
- Incorrect route or security-group rule
- Failed deployment
- Message consumer backlog
- Primary application environment
