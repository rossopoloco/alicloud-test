############################
# Application Load Balancer
############################

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

# 后端 Server Group（把传入的 ECS 都挂在 80 端口）
resource "alicloud_alb_server_group" "this" {
  server_group_name = "${var.name}-sg"
  vpc_id            = var.vpc_id
  protocol          = "HTTP"
  scheduler         = "Wrr"

  health_check_config {
    health_check_enabled      = true
    health_check_protocol     = "HTTP"
    health_check_method       = "GET"
    health_check_path         = "/"
    healthy_threshold         = 3
    unhealthy_threshold       = 3
    health_check_connect_port = 80
    health_check_interval     = 5
    health_check_timeout      = 3
  }

  dynamic "servers" {
    for_each = toset(var.server_instance_ids)
    content {
      server_id   = servers.value
      server_type = "Ecs"
      port        = 80
      weight      = 100
    }
  }

  tags = var.tags
}

# 7 层监听（HTTP: 80）-> 转发到上面的后端组
resource "alicloud_alb_listener" "http" {
  load_balancer_id  = alicloud_alb_load_balancer.this.id
  listener_protocol = "HTTP"
  listener_port     = var.listener_port

  default_actions {
    type = "ForwardGroup"
    forward_group_config {
      server_group_tuples {
        server_group_id = alicloud_alb_server_group.this.id
        weight          = 100
      }
    }
  }

  tags = var.tags
}
