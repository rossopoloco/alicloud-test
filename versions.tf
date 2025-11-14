terraform {
  required_version = ">= 1.6"

  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = ">= 1.233.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
  }
}

provider "alicloud" {
  # TFC 已通过环境变量注入：ALICLOUD_ACCESS_KEY/SECRET_KEY/REGION
  region = var.region
}
