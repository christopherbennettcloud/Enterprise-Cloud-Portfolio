# Central notification topic for infrastructure alarms
resource "aws_sns_topic" "infrastructure_alerts" {
  name = "${var.project_name}-${var.environment}-infrastructure-alerts"

  tags = {
    Name        = "${var.project_name}-${var.environment}-infrastructure-alerts"
    Project     = var.project_name
    Environment = var.environment
  }
}
# Alert when the load balancer detects unhealthy application servers
resource "aws_cloudwatch_metric_alarm" "unhealthy_application_hosts" {
  alarm_name          = "${var.project_name}-${var.environment}-unhealthy-hosts"
  alarm_description   = "Alerts when the load balancer detects an unhealthy application server."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.application.arn_suffix
    TargetGroup  = aws_lb_target_group.application.arn_suffix
  }

  alarm_actions = [aws_sns_topic.infrastructure_alerts.arn]
  ok_actions    = [aws_sns_topic.infrastructure_alerts.arn]

  tags = {
    Name        = "${var.project_name}-${var.environment}-unhealthy-hosts"
    Project     = var.project_name
    Environment = var.environment
  }
}
# Alert when the PostgreSQL database is running low on storage
resource "aws_cloudwatch_metric_alarm" "database_low_storage" {
  alarm_name          = "${var.project_name}-${var.environment}-database-low-storage"
  alarm_description   = "Alerts when PostgreSQL has less than 5 GiB of free storage."
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 5368709120
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.application.identifier
  }

  alarm_actions = [aws_sns_topic.infrastructure_alerts.arn]
  ok_actions    = [aws_sns_topic.infrastructure_alerts.arn]

  tags = {
    Name        = "${var.project_name}-${var.environment}-database-low-storage"
    Project     = var.project_name
    Environment = var.environment
  }
}
# Alert when the application server fleet has sustained high CPU usage
resource "aws_cloudwatch_metric_alarm" "application_high_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-application-high-cpu"
  alarm_description   = "Alerts when average application server CPU remains above 80 percent."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.application.name
  }

  alarm_actions = [aws_sns_topic.infrastructure_alerts.arn]
  ok_actions    = [aws_sns_topic.infrastructure_alerts.arn]

  tags = {
    Name        = "${var.project_name}-${var.environment}-application-high-cpu"
    Project     = var.project_name
    Environment = var.environment
  }
}
# Alert when PostgreSQL CPU usage remains high
resource "aws_cloudwatch_metric_alarm" "database_high_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-database-high-cpu"
  alarm_description   = "Alerts when PostgreSQL CPU usage remains above 80 percent."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.application.identifier
  }

  alarm_actions = [aws_sns_topic.infrastructure_alerts.arn]
  ok_actions    = [aws_sns_topic.infrastructure_alerts.arn]

  tags = {
    Name        = "${var.project_name}-${var.environment}-database-high-cpu"
    Project     = var.project_name
    Environment = var.environment
  }
}