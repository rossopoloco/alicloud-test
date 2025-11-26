############################
# Application Load Balancer
############################

# 仅当开启 ALB 时才创建相关资源
locals {
  enable_alb = var.enable_alb ? true : false
}

# 专用安全组：只放行 80/443
resource "alicloud_security_group" "alb" {
  count               = local.enable_alb ? 1 : 0
  vpc_id              = alicloud_vpc.this.id
  security_group_name = "${var.name_prefix}-${var.env}-alb-sg"
  tags                = local.tags
}

resource "alicloud_security_group_rule" "alb_ingress_http" {
  count             = local.enable_alb ? 1 : 0
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = alicloud_security_group.alb[0].id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "alb_ingress_https" {
  count             = local.enable_alb ? 1 : 0
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 2
  security_group_id = alicloud_security_group.alb[0].id
  cidr_ip           = "0.0.0.0/0"
}

# 公网 ALB
resource "alicloud_alb_load_balancer" "this" {
  count                 = local.enable_alb ? 1 : 0
  load_balancer_name    = "${var.name_prefix}-${var.env}-alb"
  address_type          = "Internet"                 # 公网型
  vpc_id                = alicloud_vpc.this.id
  security_group_ids    = [alicloud_security_group.alb[0].id]
  load_balancer_edition = "Standard"

  # 可用区映射（至少 1 个）；使用现有 vswitch 与可用区
  zone_mappings {
    zone_id    = data.alicloud_zones.this.zones[0].id
    vswitch_id = alicloud_vswitch.this.id
  }

  # 计费 / 带宽（必需放在该子块内）
  load_balancer_billing_config {
    pay_type             = "PayAsYouGo"
    internet_charge_type = "PayByTraffic"
    bandwidth            = var.alb_bandwidth_mbps
  }

  # 固定公网地址（可选）
  address_allocated_mode = "Fixed"

  tags = local.tags
}

# 后端 Server Group（将所有 ECS 的 80 端口挂到后端组）
resource "alicloud_alb_server_group" "ecs" {
  count             = local.enable_alb ? 1 : 0
  server_group_name = "${var.name_prefix}-${var.env}-alb-backend"
  vpc_id            = alicloud_vpc.this.id
  protocol          = "HTTP"
  scheduler         = "Wrr"

  health_check_config {
    health_check_enabled      = true
    health_check_protocol     = "HTTP"
    health_check_method       = "GET"
    health_check_path         = "/"
    health_check_connect_port = 80
    healthy_threshold         = 3
    unhealthy_threshold       = 3
    health_check_interval     = 5
    health_check_timeout      = 3
  }

  dynamic "servers" {
    for_each = local.enable_alb ? toset([for i in alicloud_instance.ecs : i.id]) : []
    content {
      server_id   = servers.value
      server_type = "Ecs"
      port        = 80
      weight      = 100
    }
  }

  tags = local.tags
}

# 7 层监听（HTTP:80）转发至上面的后端组
resource "alicloud_alb_listener" "http" {
  count            = local.enable_alb ? 1 : 0
  listener_protocol = "HTTP"
  listener_port     = 80
  load_balancer_id  = alicloud_alb_load_balancer.this[0].id

  default_actions {
    type = "ForwardGroup"
    forward_group_config {
      server_group_tuples {
        server_group_id = alicloud_alb_server_group.ecs[0].id
        weight          = 100
      }
    }
  }

  tags = local.tags
}

# 输出 ALB 公网域名（便于测试）
output "alb_dns_name" {
  value       = local.enable_alb ? alicloud_alb_load_balancer.this[0].dns_name : null
  description = "ALB 公网域名（直接访问测试用）"
}
