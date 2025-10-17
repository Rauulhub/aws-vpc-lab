# =====================
# VPC
# =====================
resource "aws_vpc" "cmtr_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "cmtr-d8cbjg27-01-vpc"
  }
}

# =====================
# Public Subnets
# =====================
resource "aws_subnet" "cmtr_public_subnets" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.cmtr_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "cmtr-d8cbjg27-01-subnet-public-${each.key}"
  }
}

# =====================
# Internet Gateway
# =====================
resource "aws_internet_gateway" "cmtr_igw" {
  vpc_id = aws_vpc.cmtr_vpc.id
  tags = {
    Name = "cmtr-d8cbjg27-01-igw"
  }
}

# =====================
# Route Table
# =====================
resource "aws_route_table" "cmtr_rt" {
  vpc_id = aws_vpc.cmtr_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cmtr_igw.id
  }
  tags = {
    Name = "cmtr-d8cbjg27-01-rt"
  }
}

# =====================
# Route Table Associations
# =====================
resource "aws_route_table_association" "cmtr_public_associations" {
  for_each       = aws_subnet.cmtr_public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.cmtr_rt.id
}
