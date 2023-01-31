provider "netapp-cloudmanager" {
  refresh_token         = var.cloudmanager_refresh_token
  sa_secret_key         = var.cloudmanager_sa_secret_key
  sa_client_id          = var.cloudmanager_sa_client_id
}


resource "netapp-cloudmanager_connector_aws" "cl_occm_aws" {
  provider = netapp-cloudmanager
  name = "TF-ConnectorAWS"
  region = var.aws_region
  key_name = aws_key_pair.ssh_key.key_name
  company = "NetApp"
  instance_type = "t3.xlarge"
  subnet_id = aws_subnet.public2[0].id
  security_group_id = aws_security_group.sg_cloud_manager.id
  iam_instance_profile_name = aws_iam_instance_profile.bluexp_connector_profile.name
  account_id = var.account_id
}


resource "netapp-cloudmanager_cvo_aws" "cvo-aws" {
  provider = netapp-cloudmanager
  name = "tfcvo01"
  region       = var.aws_region
  subnet_id    = aws_subnet.public2[0].id
  vpc_id       = aws_vpc.vpc2.id
  svm_password = var.svm_password
  security_group_id = aws_security_group.sg_cloud_manager.id
  workspace_id = "workspace-NdlFYtxK"
  ebs_volume_size_unit = "TB"
  ebs_volume_size = 1
  ebs_volume_type = "gp2"
  client_id = netapp-cloudmanager_connector_aws.cl_occm_aws.client_id
  writing_speed_state = "NORMAL"
}

