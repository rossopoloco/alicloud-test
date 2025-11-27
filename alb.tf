# 仅当 enable_alb = true 时才创建
module "alb" {
  count = var.enable_alb ? 1 : 0

  source = "./modules/alb"

  name_prefix = var.name_prefix
  env         = var.env

  vpc_id     = alicloud_vpc.this.id
  vswitch_id = alicloud_vswitch.this.id
  zone_id    = data.alicloud_zones.this.zones[0].id

  bandwidth_mbps  = var.alb_bandwidth_mbps
  listener_port   = 80
  # 把所有 ECS 挂到后端组 80 端口
  server_instance_ids = [for i in alicloud_instance.ecs : i.id]

  tags = local.tags
}

# 可选输出，便于在根模块看到 DNS
output "alb_dns_name" {
  value       = var.enable_alb ? module.alb[0].alb_dns_name : null
  description = "ALB 公网域名（仅在 enable_alb=true 时有值）"
}
