locals {
  tags = {
    Project = var.name_prefix
    Env     = var.env
  }
}

# 可用区
data "alicloud_zones" "this" {
  available_resource_creation = "VSwitch"
}
