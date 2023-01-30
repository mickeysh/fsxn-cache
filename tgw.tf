resource "aws_ec2_transit_gateway" "tftransit" {
  description = "tftransit"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags                            = {
    Name                          = "tftransit"

  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tf-tgw-att-vpc1" {
  subnet_ids         = tolist(aws_subnet.public1.*.id)
  transit_gateway_id = "${aws_ec2_transit_gateway.tftransit.id}"
  vpc_id             = "${aws_vpc.vpc1.id}"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags               = {
    Name             = "tftransit-vpc1"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tf-tgw-att-vpc2" {
  subnet_ids         = tolist(aws_subnet.public2.*.id)
  transit_gateway_id = aws_ec2_transit_gateway.tftransit.id
  vpc_id             = aws_vpc.vpc2.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags               = {
    Name             = "tftransit-vpc2"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tf-tgw-rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tftransit.id
  tags               = {
    Name             = "tf-tgw-rt"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "tf-tgw-rt-vpc-1-assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tf-tgw-att-vpc1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tf-tgw-rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tf-tgw-rt-vpc-2-assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tf-tgw-att-vpc2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tf-tgw-rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tf-tgw-rt-to-vpc-1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tf-tgw-att-vpc1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tf-tgw-rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tf-tgw-rt-to-vpc-2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tf-tgw-att-vpc2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tf-tgw-rt.id
}

resource "aws_ec2_transit_gateway_route" "tf-tgw-route" {
  destination_cidr_block         = "${tostring(tolist(aws_fsx_ontap_file_system.fsxcache.endpoints[0].management[0].ip_addresses)[0])}/32"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tf-tgw-att-vpc1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tf-tgw-rt.id
}