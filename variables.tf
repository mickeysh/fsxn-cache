
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
  description = "aws account id"
  sensitive = true
}

variable "workspace_id" {
  description = "BlueXP workspace ID"
  sensitive = true
}

variable "cloudmanager_refresh_token" {
  description = "Cloud manager refresh token"
  sensitive = true
}

variable "cloudmanager_sa_client_id" {
  description = "Cloud Manager Service account Client ID"
  sensitive = true
}

variable "cloudmanager_sa_secret_key" {
  description = "Cloud Manager Service account Secret key"
  sensitive = true
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