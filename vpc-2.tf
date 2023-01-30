

resource "aws_vpc" "vpc2" {
  cidr_block           = var.vpc_cidr_2
  tags = {
    "Name" = "vpc2"
  }
}

# SUBNETS
resource "aws_subnet" "public2" {
  map_public_ip_on_launch = "true"
  count                   = 2
  cidr_block              = cidrsubnet(var.vpc_cidr_2,8,count.index)
  vpc_id                  = aws_vpc.vpc2.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    "Name" = "Public_subnet_${regex(".$", data.aws_availability_zones.available.names[count.index])}_${aws_vpc.vpc1.id}"
  }
}

# IGW
resource "aws_internet_gateway" "igw2" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    "Name" = "IGW_${aws_vpc.vpc2.id}"
  }
}

# ROUTING #
resource "aws_route_table" "route_table2" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    "Name" = "RTB_${aws_vpc.vpc2.id}"
  }
}

resource "aws_route_table_association" "public2" {
  count          = 2
  subnet_id      = aws_subnet.public2.*.id[count.index]
  route_table_id = aws_route_table.route_table2.id
}

resource "aws_route" "route_igw2" {
  route_table_id         = aws_route_table.route_table2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw2.id
}

resource "aws_route" "route_tgw2" {
  route_table_id         = aws_route_table.route_table2.id
  destination_cidr_block = var.vpc_cidr_1
  transit_gateway_id = aws_ec2_transit_gateway.tftransit.id
}

resource "aws_route" "route_fsx2" {
  route_table_id         = aws_route_table.route_table2.id
  destination_cidr_block = "${tostring(tolist(aws_fsx_ontap_file_system.fsxcache.endpoints[0].management[0].ip_addresses)[0])}/32"
  transit_gateway_id = aws_ec2_transit_gateway.tftransit.id
}