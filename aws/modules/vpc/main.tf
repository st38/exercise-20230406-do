# VPC
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    Name = local.name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = local.name
  }
}

# Subnets
resource "aws_subnet" "this" {
  for_each = { for idx, az in local.az_list : idx => az }

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.cidr_block, 2, each.key)
  availability_zone = each.value

  tags = {
    Name = "${local.name}-${each.value}"
  }
}

# Route table
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = local.name
  }
}

# Route table association
resource "aws_route_table_association" "this" {
  for_each = { for idx, subnet in aws_subnet.this : idx => subnet.id }

  route_table_id = aws_route_table.this.id
  subnet_id      = each.value
}

# Route table - Default
resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id
  route                  = []

  tags = {
    Name = "${local.name} - default"
  }
}

# Security group
resource "aws_security_group" "this" {
  name        = local.name
  description = "${local.name} access"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "All - SG"
    protocol    = -1
    self        = true
    from_port   = 0
    to_port     = 0
  }

  ingress {
    description = "SSH - Any"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.name
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Security group - Default
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.name} - default"
  }
}
