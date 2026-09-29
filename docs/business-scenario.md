# Enterprise Logistics Shipment-Tracking Platform

## Business Scenario

A growing regional logistics company coordinates shipments for commercial customers across multiple distribution locations. The company currently relies on spreadsheets, emails, and telephone calls to create shipments, communicate tracking information, and record delivery updates.

As shipment volume increases, this manual process creates several business problems:

- Customers must call employees to request shipment updates.
- Tracking information is distributed across multiple spreadsheets.
- Employees can accidentally enter inconsistent or duplicate information.
- The existing process cannot scale efficiently as shipment volume grows.
- A server or application failure could interrupt the entire operation.
- Infrastructure changes are performed manually and are difficult to reproduce.
- The company lacks centralized monitoring and automated recovery.

The company needs a secure, highly available shipment-tracking platform hosted on AWS.

## Proposed Solution

The proposed solution is a web-based logistics application that allows employees to create and update shipments while allowing customers to search for shipments using a unique tracking number.

The application and its supporting AWS infrastructure will be deployed using Terraform. The solution will distribute traffic across multiple application servers and Availability Zones so that the platform can remain operational if one server fails.

## Application Users

### Customers

Customers will be able to:

- Search for a shipment using a tracking number.
- View the shipment’s current status.
- View the shipment origin and destination.
- View the estimated delivery date.
- Review shipment-status history.

### Logistics Employees

Authorized employees will be able to:

- Create a new shipment.
- Generate a unique tracking number.
- Enter shipment origin and destination information.
- Update shipment status.
- Record shipment-history events.
- Search for existing shipments.

## Example Shipment Statuses

The application will support shipment statuses such as:

- Shipment Created
- Picked Up
- In Transit
- At Distribution Center
- Out for Delivery
- Delivered
- Delayed
- Exception

## Business Requirements

The solution must:

1. Provide a functional web interface for shipment tracking.
2. Store shipment information in a persistent database.
3. Distribute application traffic through a load balancer.
4. Run application servers across at least two Availability Zones.
5. Prevent customers from connecting directly to application servers.
6. Place application servers and the database in private subnets.
7. Automatically replace an unhealthy application server.
8. Monitor infrastructure and application health.
9. Allow the environment to be created consistently with Terraform.
10. Include a documented process for testing and destroying the environment.

## Technical Scope

The completed project is planned to include:

- One Amazon VPC
- Two public subnets across two Availability Zones
- Two private application subnets across two Availability Zones
- Internet gateway and route tables
- Application Load Balancer
- EC2 application servers
- Auto Scaling Group
- Launch template
- Shipment database
- Security groups using tier-based access
- IAM roles instead of credentials stored in application code
- CloudWatch logs, metrics, and alarms
- Terraform infrastructure as code
- GitHub Actions validation
- Deployment, testing, recovery, and cleanup documentation

## Security Design

The platform will use a layered security model:

- The load balancer will be the public entry point.
- Application servers will accept application traffic only from the load balancer.
- The database will accept database traffic only from the application tier.
- Application servers will not store permanent AWS access keys.
- IAM roles will provide temporary permissions where required.
- Security groups will follow least-privilege principles.
- Secrets will not be committed to the GitHub repository.
- Sensitive data will be protected in transit and at rest where supported.

## Availability and Recovery

The application tier will operate across two Availability Zones. The load balancer will send requests only to healthy application instances.

An Auto Scaling Group will maintain the required number of application servers. If an instance becomes unhealthy or is terminated during testing, AWS should launch a replacement instance automatically.

The project will include a controlled failure test to demonstrate this recovery process.

## Automation

Terraform will define the AWS infrastructure so that the environment is:

- Repeatable
- Version controlled
- Reviewable before deployment
- Rebuildable after destruction
- Less dependent on manual console configuration

GitHub Actions will automatically check Terraform formatting and configuration validity when code is pushed to the repository.

## Cost-Control Strategy

This project is intended as a portfolio demonstration rather than a permanently running production service.

To control costs:

- Billable resources will be deployed only during testing.
- The Terraform plan will be reviewed before deployment.
- Small resource sizes will be selected where practical.
- Expensive services will be evaluated before use.
- Resources will be destroyed after testing and evidence collection.
- Terraform code and project documentation will remain in GitHub after the live environment is removed.

## Success Criteria

The project will be considered successful when:

- A user can access the application through the load balancer.
- An employee can create a shipment.
- The application generates or stores a tracking number.
- Shipment status can be updated.
- A customer can retrieve shipment information.
- Data remains available between application requests.
- Load-balancer health checks pass.
- Terminating one application instance does not permanently interrupt service.
- CloudWatch records operational information.
- Terraform can create and destroy the environment successfully.
- The repository contains clear architecture, testing, security, and cleanup documentation.

## Current Project Status

The network foundation has been written and successfully validated with Terraform.

The current Terraform plan contains 15 resources, including:

- VPC
- Internet gateway
- Two public subnets
- Two private application subnets
- Public and private route tables
- Route-table associations
- Load-balancer security group
- Application security group

No AWS infrastructure has been deployed yet. The next stage is to expand the Terraform configuration to support the functional application before reviewing a new plan and deciding when to deploy.