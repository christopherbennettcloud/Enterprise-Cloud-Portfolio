# Create two isolated private subnets for the PostgreSQL database
resource "aws_subnet" "private_db" {
  count = length(var.private_db_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_db_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-db-${count.index + 1}"
    Project     = var.project_name
    Environment = var.environment
    Tier        = "database"
  }
}
# Group the two private database subnets for Amazon RDS
resource "aws_db_subnet_group" "application" {
  name = "${var.project_name}-${var.environment}-db-subnets"

  subnet_ids = aws_subnet.private_db[*].id

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-subnets"
    Project     = var.project_name
    Environment = var.environment
  }
}
# Allow PostgreSQL access only from the application servers
resource "aws_security_group" "database" {
  name_prefix = "${var.project_name}-${var.environment}-db-"
  description = "Allows PostgreSQL traffic only from the application tier."
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL from application servers"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.application.id]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-sg"
    Project     = var.project_name
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}
# Create the private PostgreSQL database
resource "aws_db_instance" "application" {
  identifier = "${var.project_name}-${var.environment}-postgres"

  engine         = "postgres"
  instance_class = "db.t4g.micro"

  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = "logistics"
  username = "logistics_admin"

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.application.name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period    = 7
  auto_minor_version_upgrade = true

  deletion_protection = false
  skip_final_snapshot = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-postgres"
    Project     = var.project_name
    Environment = var.environment
  }
}