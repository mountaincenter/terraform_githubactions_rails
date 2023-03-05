# =============
# VPC
# =============

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.tool}-${var.project}-${var.environment}-vpc"
  }
}

# ================
# Public Subnet
# ================

resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.tool}-${var.project}-${var.environment}-public-${count.index}"
  }
}

# ================
# Private Subnet
# ================

resource "aws_subnet" "private" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.tool}-${var.project}-${var.environment}-private-${count.index}"
  }
}