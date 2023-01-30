
variable "vpc_cidr_1" {
  default = "10.0.0.0/16"
  description = "default CIDR range of the VPC"
}

variable "vpc_cidr_2" {
  default = "10.1.0.0/16"
  description = "default CIDR range of the VPC"
}

variable "aws_region" {
  default = "us-west-2"
  description = "aws region"
}

variable "fsx_capacity" {
  default = 2048
  description = "default FSxN storage capacity"
}
variable "fsx_admin_password" {
  default = "Netapp1!"
  description = "default FSxN filesystem admin password"
}

variable "account_id" {
  default = "account-46F1HgyQ"
  description = "aws account id"
}

variable "workspace_id" {
  default = "workspace-NdlFYtxK"
  description = "BlueXP workspace ID"
}

variable "cloudmanager_refresh_token" {
  description = "Cloud manager refresh token"
}

variable "cloudmanager_sa_client_id" {
  description = "Cloud Manager Service account Client ID"
}

variable "cloudmanager_sa_secret_key" {
  description = "Cloud Manager Service account Secret key"
}

variable "svm_password" {
  default = "Netapp1!"
  description = "default svm admin password"
}

variable "ubuntu_account_number" {
  default = "099720109477"
}

variable "instance_type" {
  description = "The type of the ec2, for example - t2.medium"
  type        = string
  default     = "t2.micro"
}