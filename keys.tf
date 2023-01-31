resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "coredns_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_sensitive_file" "ssh_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename           = "ssh_key.pem"
}