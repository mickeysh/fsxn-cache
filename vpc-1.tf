
provider "aws" {
  region  = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "group-name"
    values = [var.aws_region]
  }
}

resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc_cidr_1
  tags = {
    "Name" = "vpc1"
  }
}

# SUBNETS
resource "aws_subnet" "public1" {
  map_public_ip_on_launch = "true"
  count                   = 2
  cidr_block              = cidrsubnet(var.vpc_cidr_1,8,count.index)
  vpc_id                  = aws_vpc.vpc1.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    "Name" = "Public_subnet_${regex(".$", data.aws_availability_zones.available.names[count.index])}_${aws_vpc.vpc1.id}"
  }
}

# IGW
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    "Name" = "IGW_${aws_vpc.vpc1.id}"
  }
}

# ROUTING #
resource "aws_route_table" "route_table1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    "Name" = "RTB_${aws_vpc.vpc1.id}"
  }
}

resource "aws_route_table_association" "public1" {
  count          = 2
  subnet_id      = aws_subnet.public1.*.id[count.index]
  route_table_id = aws_route_table.route_table1.id
}

resource "aws_route" "route_igw1" {
  route_table_id         = aws_route_table.route_table1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw1.id
}

resource "aws_route" "route_tgw1" {
  route_table_id         = aws_route_table.route_table1.id
  destination_cidr_block = var.vpc_cidr_2
  transit_gateway_id = aws_ec2_transit_gateway.tftransit.id
}

