output "fsx_endpoints" {
  description = "FSxN filsystem ID"
  value = aws_fsx_ontap_file_system.fsxcache.endpoints
}

output "cvo" {
  value = netapp-cloudmanager_cvo_aws.cvo-aws.cluster_floating_ip
}

output "fsx_ip" {
  description = "FSxN filsystem IP"
  value = tostring(tolist(aws_fsx_ontap_file_system.fsxcache.endpoints[0].management[0].ip_addresses)[0])
}

output "fsx_intercluster_1" {
  description = "FSxN Intercluster ID"
  value = tostring(tolist(aws_fsx_ontap_file_system.fsxcache.endpoints[0].intercluster[0].ip_addresses)[0])
}

output "fsx_intercluster_2" {
  description = "FSxN Intercluster ID"
  value = tostring(tolist(aws_fsx_ontap_file_system.fsxcache.endpoints[0].intercluster[0].ip_addresses)[1])
}
