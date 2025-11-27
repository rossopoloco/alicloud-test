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

module "alb" {
  source = "./modules/alb"
  count  = var.enable_alb ? 1 : 0

  name       = "${var.name}-${var.env}-alb"
  vpc_id     = alicloud_vpc.this.id
  vswitch_id = alicloud_vswitch.this.id
  zone_id    = data.alicloud_zones.this.zones[0].id
  env         = var.env

  listener_port        = var.alb_listener_port
  backend_port         = 80
  backend_instance_ids = [for i in alicloud_instance.ecs : i.id]

  tags = local.tags
}

