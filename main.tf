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

# 其他已有资源（VPC/VSwitch/SG/ECS/RDS/OSS）保持不变
# 只保留这一处 ALB 模块调用

module "alb" {
  source = "./modules/alb"

  # 从根模块把值传给子模块
  name_prefix = var.name_prefix
  env         = var.env

  vpc_id     = alicloud_vpc.this.id
  vswitch_id = alicloud_vswitch.this.id
  zone_id    = data.alicloud_zones.this.zones[0].id

  alb_listener_port   = var.alb_listener_port
  alb_server_port     = 80
  alb_bandwidth_mbps  = var.alb_bandwidth_mbps

  backend_ecs_ids = [for i in alicloud_instance.ecs : i.id]

  tags = local.tags
}
