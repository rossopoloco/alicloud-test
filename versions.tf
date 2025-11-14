terraform {
  required_version = ">= 1.6"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.210" # 需要确定，稳定大版本，必要时可放宽
    }
  }
  cloud {
    organization = "rosso"   # 需要确定，TFC 组织
    workspaces { name = "alicloud-test" }  # 需要确定，对应你的工作空间名
  }
}