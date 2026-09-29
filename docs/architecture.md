# Enterprise Logistics Platform Architecture

## Architecture Objective

The target architecture provides a secure, scalable, and highly available environment for a functional shipment-tracking application.

The solution separates public traffic, application processing, and database storage into different security layers. Terraform will create the infrastructure, while GitHub Actions will validate the configuration.

## Planned Architecture

```mermaid
flowchart TD
    U[Customers and Employees] --> ALB[Application Load Balancer]
    ALB --> ASG[EC2 Auto Scaling Group]
    ASG --> RDS[(PostgreSQL Database)]
    ASG --> CW[CloudWatch]
    SM[Secrets Manager] --> ASG
    TF[Terraform] --> AWS[AWS Infrastructure]
    GH[GitHub Actions] --> TF
   ```

## Network Design

The platform will use one Amazon VPC distributed across two Availability Zones.

### Public Subnets

Two public subnets will contain:

- The Application Load Balancer
- NAT Gateways required for controlled outbound internet access

Public subnets will have routes to the internet gateway.

### Private Application Subnets

Two private application subnets will contain the EC2 application servers managed by an Auto Scaling Group.

The application servers will:

- Have no public IP addresses
- Accept port 8080 traffic only from the load balancer
- Use NAT Gateways when outbound internet access is required
- Use an IAM instance role for AWS permissions
- Send logs and metrics to CloudWatch

### Private Database Subnets

Two private database subnets will support the database subnet group.

The database will:

- Not be publicly accessible
- Accept database connections only from the application security group
- Store shipment, user, and shipment-history information
- Use encrypted storage
- Keep credentials outside the application source code

## Request Flow

1. A customer or employee opens the application.
2. The request reaches the public Application Load Balancer.
3. The load balancer checks for a healthy application target.
4. The request is forwarded to an EC2 application server on port 8080.
5. The application processes the request.
6. When necessary, the application securely communicates with the database.
7. The application returns the response through the load balancer.
8. Logs and operational metrics are sent to CloudWatch.

## Application Load Balancer

The Application Load Balancer will:

- Operate across both public subnets
- Provide a single application endpoint
- Distribute requests across healthy application instances
- Perform health checks
- Stop sending traffic to unhealthy instances
- Forward application traffic to port 8080

The demonstration environment may initially use HTTP. HTTPS with AWS Certificate Manager and a custom domain is a planned production improvement.

## Compute Layer

The compute layer will use:

- EC2 launch template
- Auto Scaling Group
- Two Availability Zones
- Minimum capacity of two instances
- Desired capacity of two instances
- Configurable maximum capacity
- Application Load Balancer health checks

The launch template will define:

- Amazon Machine Image
- Instance type
- Application security group
- IAM instance profile
- Encrypted root storage
- Startup configuration
- Application installation and launch process
 ## Auto Scaling and Recovery

The Auto Scaling Group will maintain the required number of healthy application servers.

If an application server fails:

1. The load balancer marks it unhealthy.
2. Traffic is directed to the remaining healthy server.
3. Auto Scaling launches a replacement server.
4. The replacement completes its health check.
5. The load balancer begins sending traffic to it.

This process will be demonstrated through a controlled failure test.

## Application Design

The initial application will use Python, HTML, and CSS.

Customers will be able to:

- Search by tracking number
- View current shipment status
- View origin and destination
- View the estimated delivery date
- View shipment-history events

Authorized employees will be able to:

- Sign in
- Create shipments
- Generate tracking numbers
- Update shipment status
- Add shipment-history events
- Search and review shipments

## Database Design

The planned database engine is PostgreSQL running on Amazon RDS.

The database will store:

- Employees
- Customers
- Shipments
- Shipment-status history

The database will use:

- Private database subnets
- A dedicated database security group
- Encrypted storage
- Automated backups during deployment
- Credentials kept outside the application source code

A small Single-AZ database may be used during the short portfolio demonstration to control cost. A production implementation would use Multi-AZ RDS for database failover.

## Security Groups

### Load Balancer Security Group

Allows:

- Inbound web traffic from users
- Outbound traffic to the application tier

### Application Security Group

Allows:

- Inbound port 8080 traffic only from the load balancer
- Required outbound access
- Connections to the database tier

### Database Security Group

Allows:

- PostgreSQL traffic only from the application security group
- No direct public access

## Identity and Secrets

The design will avoid storing AWS access keys or database passwords in GitHub.

Planned controls include:

- IAM role attached to EC2 instances
- Least-privilege IAM policies
- Temporary credentials supplied through the instance role
- Secure database credential storage
- No secrets committed to Terraform variable files
- Sensitive Terraform values marked appropriately

## Monitoring

Amazon CloudWatch will monitor:

- EC2 CPU utilization
- Instance health
- Load-balancer healthy-host count
- Load-balancer unhealthy-host count
- HTTP errors
- Application logs
- Database health
- Important alarm conditions

## Infrastructure as Code

Terraform will manage the infrastructure lifecycle.

The workflow will be:

1. Run `terraform fmt`.
2. Run `terraform validate`.
3. Run `terraform plan`.
4. Review the proposed changes.
5. Run `terraform apply`.
6. Test and document the environment.
7. Run `terraform destroy`.

No deployment will occur without reviewing the Terraform plan.

## Continuous Integration

GitHub Actions will automatically check:

- Terraform formatting
- Terraform initialization
- Terraform validation
- Additional security checks where practical

The GitHub workflow will validate the code without automatically creating billable AWS resources.

## Availability Strategy

The application tier will be designed to tolerate the failure of one EC2 instance.

Availability features include:

- Two Availability Zones
- Two public subnets
- Two private application subnets
- Multiple application instances
- Load-balancer health checks
- Auto Scaling replacement
- Database backup and recovery planning

The demonstration database may remain Single-AZ for cost control. This limitation will be clearly documented instead of being presented as full database high availability.

## Cost-Control Decisions

Because this is a temporary portfolio environment:

- Small configurable resource sizes will be used.
- The Terraform plan will be reviewed before deployment.
- Billable infrastructure will run only during testing.
- Testing and evidence collection will occur during the same session.
- `terraform destroy` will remove the infrastructure afterward.
- Code, diagrams, screenshots, and test results will remain in GitHub.
- More expensive production alternatives will be documented.

## Planned Testing

Testing will include:

- Terraform formatting and validation
- Load-balancer health checks
- Shipment creation
- Tracking-number search
- Shipment-status updates
- Database persistence
- Unauthorized network-access attempts
- EC2 instance failure
- Auto Scaling replacement
- Terraform destruction and cleanup verification

## Design Limitations

The initial portfolio deployment may not include:

- A purchased custom domain
- Production HTTPS configuration
- Multi-AZ RDS
- Enterprise identity federation
- AWS Web Application Firewall
- Multi-region disaster recovery

These will be documented as production improvements.

## Current Status

The network foundation has been written and successfully planned.

Currently planned resources include:

- VPC
- Internet gateway
- Two public subnets
- Two private application subnets
- Public and private route tables
- Route-table associations
- Load-balancer security group
- Application security group

The load balancer, EC2 layer, Auto Scaling, database, application code, monitoring, and remaining security controls have not yet been implemented or deployed.