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
  count  = var.enable_alb ? 1 : 0

  # 生成名字，与你的命名风格一致
  name   = "${var.name_prefix}-${var.env}-alb"

  vpc_id     = alicloud_vpc.this.id
  vswitch_id = alicloud_vswitch.this.id
  zone_id    = data.alicloud_zones.this.zones[0].id

  # 直接复用现有安全组（或传 ALB 专用 SG 的 id）
  alb_sg_id  = alicloud_security_group.this.id

  # 后端挂 ECS（80端口），把所有 ECS id 传给模块
  server_instance_ids = [for i in alicloud_instance.ecs : i.id]

  # 监听端口按需求（默认 80）
  listener_port = 80

  # 标签透传
  tags = local.tags
}

# 根层只保留这一处输出（不和模块内部重名）
output "alb_dns_name" {
  value       = var.enable_alb ? module.alb[0].dns_name : null
  description = "ALB 公网域名"
}


