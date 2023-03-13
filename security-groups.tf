resource "aws_security_group" "sg_cloud_manager" {
  name_prefix = "tf_cloud_manager"
  vpc_id      = aws_vpc.vpc2.id
}

resource "aws_security_group_rule" "sg_cloud_manager_ingress" {
  description       = "allow inbound traffic to cloud manager"
  from_port         = 0
  protocol          = "-1"  
  to_port           = 65535
  security_group_id = aws_security_group.sg_cloud_manager.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_cloud_manager_http_ingress" {
  description       = "allow inbound traffic to cloud manager"
  from_port         = 80
  protocol          = "TCP"
  to_port           = 80
  security_group_id = aws_security_group.sg_cloud_manager.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_cloud_manager_https_ingress" {
  description       = "allow inbound traffic to cloud manager"
  from_port         = 443
  protocol          = "TCP"
  to_port           = 443
  security_group_id = aws_security_group.sg_cloud_manager.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_cloud_manager_ssh_ingress" {
  description       = "allow inbound traffic to cloud manager"
  from_port         = 22
  protocol          = "TCP"
  to_port           = 22
  security_group_id = aws_security_group.sg_cloud_manager.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_cloud_manager_egress" {
  description       = "allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_cloud_manager.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
