# 只有在 enable_alb=true 时创建
resource "alicloud_alb_load_balancer" "this" {
  count = var.enable_alb ? 1 : 0

  load_balancer_name = "${var.name_prefix}-${var.env}-alb"
  address_type       = "Internet"
  load_balancer_edition = "Standard"
  vpc_id             = alicloud_vpc.this.id
  zone_mappings {
    vswitch_id = alicloud_vswitch.this.id
    zone_id    = data.alicloud_zones.this.zones[0].id
  }
  tags = local.tags
}

# 简单 HTTP 监听 + 目标组（示例）
resource "alicloud_alb_server_group" "sg" {
  count = var.enable_alb ? 1 : 0

  server_group_name = "${var.name_prefix}-${var.env}-alb-sg"
  vpc_id            = alicloud_vpc.this.id

  sticky_session_config {
    sticky_session_enabled = false
  }

  health_check_config {
    health_check_enabled = true
    health_check_connect_port = 80
    health_check_host = ""
  }
}

resource "alicloud_alb_listener" "http" {
  count = var.enable_alb ? 1 : 0

  listener_protocol   = "HTTP"
  listener_port       = 80
  load_balancer_id    = alicloud_alb_load_balancer.this[0].id
  default_actions {
    type = "ForwardGroup"
    forward_group_config {
      server_group_tuples {
        server_group_id = alicloud_alb_server_group.sg[0].id
      }
    }
  }
}
