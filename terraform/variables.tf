variable "project_name" {
  description = "Short name used in resource names and tags."
  type        = string
  default     = "enterprise-logistics-platform"

  validation {
    condition     = length(var.project_name) >= 3 && length(var.project_name) <= 40
    error_message = "project_name must contain between 3 and 40 characters."
  }
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "lab"
}

variable "aws_region" {
  description = "AWS Region for the lab environment."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "Two Availability Zones used by the lab."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two Availability Zones must be supplied."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the two public subnets."
  type        = list(string)
  default     = ["10.20.0.0/24", "10.20.1.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDR blocks must be supplied."
  }
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for the two private application subnets."
  type        = list(string)
  default     = ["10.20.10.0/24", "10.20.11.0/24"]

  validation {
    condition     = length(var.private_app_subnet_cidrs) == 2
    error_message = "Exactly two private application subnet CIDR blocks must be supplied."
  }
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for the private database subnets."
  type        = list(string)
  default = [
    "10.20.20.0/24",
    "10.20.21.0/24"
  ]

  validation {
    condition     = length(var.private_db_subnet_cidrs) == 2
    error_message = "Exactly two private database subnet CIDR blocks are required."
  }
}