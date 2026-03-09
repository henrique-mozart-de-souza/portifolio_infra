resource "aws_vpc" "this" {
  for_each             = var.vpcs
  cidr_block           = each.value.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "${var.project_name}-${var.environment}-vpc-${each.key}" }
}

resource "aws_internet_gateway" "this" {
  for_each = var.vpcs
  vpc_id   = aws_vpc.this[each.key].id

  tags = { Name = "${var.project_name}-${var.environment}-igw-${each.key}" }
}

resource "aws_subnet" "this" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.this[each.value.vpc_key].id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.is_public

  tags = { Name = "${var.project_name}-${var.environment}-subnet-${each.key}" }
}

resource "aws_route_table" "public" {
  for_each = var.vpcs
  vpc_id   = aws_vpc.this[each.key].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[each.key].id
  }

  tags = { Name = "${var.project_name}-${var.environment}-rt-${each.key}" }
}

resource "aws_route_table_association" "public" {
  for_each       = { for k, v in var.subnets : k => v if v.is_public }
  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public[each.value.vpc_key].id
}