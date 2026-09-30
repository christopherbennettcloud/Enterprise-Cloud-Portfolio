# Find the latest Amazon Linux 2023 machine image in the selected AWS region
data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Define how every EC2 application server must be created
resource "aws_launch_template" "application" {
  name_prefix   = "${var.project_name}-${var.environment}-app-"
  image_id      = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.application.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_application.name
  }

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    project_name = var.project_name
    environment  = var.environment
  }))

  # Encrypt the server's storage
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 8
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  # Require the secure version of the EC2 metadata service
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.project_name}-${var.environment}-app"
      Project     = var.project_name
      Environment = var.environment
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name        = "${var.project_name}-${var.environment}-app-volume"
      Project     = var.project_name
      Environment = var.environment
    }
  }

  update_default_version = true

  lifecycle {
    create_before_destroy = true
  }
}

# Maintain application servers across both private application subnets
resource "aws_autoscaling_group" "application" {
  name_prefix = "${var.project_name}-${var.environment}-app-asg-"

  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  vpc_zone_identifier = aws_subnet.private_app[*].id
  target_group_arns   = [aws_lb_target_group.application.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.application.id
    version = "$Latest"
  }

  # Replace servers gradually when the launch template changes
  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 300
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-app"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  # Wait until the private subnets have outbound access
  depends_on = [
    aws_route.private_app_internet
  ]

  lifecycle {
    create_before_destroy = true
  }
}