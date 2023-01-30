
terraform {
  required_version = ">= 0.13"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    netapp-cloudmanager = {
      source = "NetApp/netapp-cloudmanager"
      version = "~> 23.1.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.52.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}
