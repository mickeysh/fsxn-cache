resource "aws_fsx_ontap_file_system" "fsxcache" {
  storage_capacity    = var.fsx_capacity
  subnet_ids          = aws_subnet.public1.*.id
  deployment_type     = "MULTI_AZ_1"
  throughput_capacity = 512
  preferred_subnet_id = aws_subnet.public1[0].id
  security_group_ids = [aws_security_group.fsxn_sg.id]
  fsx_admin_password = var.fsx_admin_password
  route_table_ids = [aws_route_table.route_table1.id]
  tags = {
      Name = "fsxcache"
  }
}

resource "aws_fsx_ontap_storage_virtual_machine" "fsxcachesvm" {
  file_system_id = aws_fsx_ontap_file_system.fsxcache.id
  name           = "fsxcachesvm"
}

resource "aws_security_group" "fsxn_sg" {
  name_prefix = "security group for fsx access"
  vpc_id      = aws_vpc.vpc1.id
  tags = {
      Name = "fsxn_sg"
  }
}

resource "aws_security_group_rule" "fsxn_sg_inbound" {
  description       = "allow inbound traffic to eks"
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
  security_group_id = aws_security_group.fsxn_sg.id
  type              = "ingress"
  cidr_blocks       = ["10.0.0.0/8"]
}

resource "aws_security_group_rule" "fsxn_sg_outbound" {
  description       = "allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.fsxn_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}