output "vpc_id" {
  description = "ID of the portfolio VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = aws_subnet.public[*].id
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets."
  value       = aws_subnet.private_app[*].id
}

output "load_balancer_security_group_id" {
  description = "Security group reserved for the future load balancer."
  value       = aws_security_group.load_balancer.id
}

output "application_security_group_id" {
  description = "Security group for the future application tier."
  value       = aws_security_group.application.id
}

output "application_url" {
  description = "Public URL for the logistics shipment-tracking application."
  value       = "http://${aws_lb.application.dns_name}"
}
output "database_endpoint" {
  description = "Private PostgreSQL database connection endpoint."
  value       = aws_db_instance.application.endpoint
}

output "database_master_secret_arn" {
  description = "ARN of the AWS-managed secret containing the database credentials."
  value       = aws_db_instance.application.master_user_secret[0].secret_arn
}

output "infrastructure_alerts_topic_arn" {
  description = "ARN of the SNS topic used for infrastructure alerts."
  value       = aws_sns_topic.infrastructure_alerts.arn
}