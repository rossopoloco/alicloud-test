# modules/alb/main.tf
resource "alicloud_alb_load_balancer" "this" {
  # 名称 / 基本属性
  load_balancer_name    = "${var.name_prefix}-${var.env}-alb"
  address_type          = "Internet"       # 公网
  vpc_id                = var.vpc_id
  security_group_id     = var.alb_sg_id    # <- 单数字段，不能用 security_group_ids
  load_balancer_edition = "Standard"

  # 可用区与交换机（用你传进来的 zone / vswitch）
  zone_mappings {
    zone_id    = var.zone_id
    vswitch_id = var.vswitch_id
  }

  # 计费配置（新版 Provider 要求在独立的 block）
  load_balancer_billing_config {
    pay_type            = "PayAsYouGo"
    internet_charge_type = "PayByBandwidth"
    bandwidth           = var.alb_bandwidth_mbps
  }

  tags = {
    Project = var.name_prefix
    Env     = var.env
  }
}
