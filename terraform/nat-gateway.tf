# Elastic IP address used by the NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-eip"
    Project     = var.project_name
    Environment = var.environment
  }
}

# One NAT Gateway for the cost-conscious lab environment
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Give both private application subnets outbound internet access
resource "aws_route" "private_app_internet" {
  count = length(aws_route_table.private_app)

  route_table_id         = aws_route_table.private_app[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}