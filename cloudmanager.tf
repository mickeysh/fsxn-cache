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
  workspace_id = var.workspace_id
  ebs_volume_size_unit = "TB"
  ebs_volume_size = 4
  ebs_volume_type = "gp2"
  client_id = netapp-cloudmanager_connector_aws.cl_occm_aws.client_id
  writing_speed_state = "NORMAL"
}


resource "netapp-cloudmanager_aws_fsx" "aws-fsx" {
  name = "fsxcache"
  tenant_id    = var.account_id
  workspace_id = var.workspace_id
  aws_credentials_name = "RN-FSxN-Creds"
  provider = netapp-cloudmanager
  region = var.aws_region
  import_file_system = true
  file_system_id = aws_fsx_ontap_file_system.fsxcache.id
  fsx_admin_password = var.fsx_admin_password
  primary_subnet_id = aws_subnet.public1[0].id
  secondary_subnet_id = aws_subnet.public1[1].id
  throughput_capacity = var.fsx_capacity
}

resource "netapp-cloudmanager_aws_fsx_volume" "aws-fsx-volume-nfs" {
  provider     = netapp-cloudmanager
  tenant_id    = var.account_id
  file_system_id = netapp-cloudmanager_aws_fsx.aws-fsx.id
  client_id = netapp-cloudmanager_connector_aws.cl_occm_aws.client_id

  volume_protocol = "nfs"
  name = "vol1"
  size = 10
  unit = "GB"
  export_policy_type = "custom"
  export_policy_ip = ["0.0.0.0/0"]
  export_policy_nfs_version = ["nfs4"]
}


resource "netapp-cloudmanager_snapmirror" "aws-cl-snapmirror" {
  provider = netapp-cloudmanager
  tenant_id    = var.account_id

  source_working_environment_id = netapp-cloudmanager_aws_fsx.aws-fsx.id
  source_volume_name = netapp-cloudmanager_aws_fsx_volume.aws-fsx-volume-nfs.name
  source_svm_name = aws_fsx_ontap_storage_virtual_machine.fsxcachesvm.name
  
  destination_working_environment_id = netapp-cloudmanager_cvo_aws.cvo-aws.id
  destination_volume_name = "vol1_copy"
  destination_svm_name = netapp-cloudmanager_cvo_aws.cvo-aws.svm_name
  provider_volume_type = "gp2"

  policy = "MirrorAllSnapshots"
  schedule = "5min"
  destination_aggregate_name = "aggr1"
  max_transfer_rate = "102400"
  client_id = netapp-cloudmanager_connector_aws.cl_occm_aws.client_id
}