
# resource "null_resource" "fsx_cli" {

# connection {
#     host = "${element(aws_instance.clientnode.*.private_ip, count.index)}"
# }

# provisioner "remote-exec" {
#     inline = [
#     "sudo service example-client restart"
#     ]
# }
# }

data "aws_ami" "ubuntu-18" {
  most_recent = true
  owners      = [var.ubuntu_account_number]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  subnet_id                   = aws_subnet.public1[0].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_instances_access.id]

  tags = {
    "Name" = "tfbastion"
  }
}

resource "aws_security_group" "bastion_instances_access" {
  vpc_id = aws_vpc.vpc1.id
  name   = "bastion-access"

  tags = {
    "Name" = "bastion-access"
  }
}

resource "aws_security_group_rule" "bastion_ssh_acess" {
  description       = "allow ssh access from anywhere"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion_instances_access.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion_outbound_anywhere" {
  description       = "allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.bastion_instances_access.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}