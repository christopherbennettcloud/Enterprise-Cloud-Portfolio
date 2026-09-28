# Nonfunctional Requirements

These are portfolio targets, not claims about a production service-level agreement.

| Area | Initial target | Validation method |
|---|---|---|
| Availability | Continue serving traffic after one application instance fails | Terminate one instance/container during a load test |
| Scalability | Add application capacity without redesigning the network | Auto Scaling test with synthetic traffic |
| Recovery time objective | Restore critical application service within 30 minutes | Timed recovery exercise |
| Recovery point objective | Lose no more than 5 minutes of accepted transaction data | Event and data recovery test |
| Security | No direct internet access to application or data tiers | Network-path and security-group review |
| Repeatability | Rebuild infrastructure from code | Clean Terraform deploy after destroy |
| Observability | Detect application or infrastructure failure within 5 minutes | Alarm and dashboard test |
| Change safety | Validate infrastructure changes before deployment | Pull-request Terraform checks |
| Cost control | No persistent high-cost services in the lab | Budget alerts and post-destroy review |
| Portability | Separate application behavior from cloud provisioning | Containerized application and decision records |

## Future enterprise considerations

- Regulatory and payment-card requirements
- Formal service-level agreements
- Identity federation and centralized access reviews
- Multi-account governance
- Security operations integration
- Capacity forecasting
- Data residency
- Vendor support and licensing
- Business continuity exercises
