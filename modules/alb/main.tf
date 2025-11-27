locals {
  lb_name = "${var.name_prefix}-${var.env}-alb"
}

# 公网 ALB
resource "alicloud_alb_load_balancer" "this" {
  load_balancer_name    = local.lb_name
  address_type          = "Internet"          # 公网
  vpc_id                = var.vpc_id
  load_balancer_edition = "Standard"

  # ✅ 新版必须：计费配置。按量付费即可。
  load_balancer_billing_config {
    pay_type = "PayAsYouGo"
  }

  # 至少需要一个可用区映射
  zone_mappings {
    zone_id    = var.zone_id
    vswitch_id = var.vswitch_id
  }

  # 固定公网地址（可选）
  address_allocated_mode = "Fixed"

  tags = var.tags
}

# 后端 Server Group（把传入的 ECS 全部挂上）
resource "alicloud_alb_server_group" "ecs" {
  server_group_name = "${local.lb_name}-sg"
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
    health_check_interval     = 5
    health_check_connect_port = var.backend_port
    health_check_timeout      = 3
  }

  dynamic "servers" {
    for_each = var.backend_instance_ids
    content {
      server_id   = servers.value
      server_type = "Ecs"
      port        = var.backend_port
      weight      = 100
    }
  }

  tags = var.tags
}

# 监听器（HTTP -> 转发到上面的后端组）
resource "alicloud_alb_listener" "http" {
  listener_protocol = "HTTP"
  listener_port     = var.listener_port
  load_balancer_id  = alicloud_alb_load_balancer.this.id

  default_actions {
    type = "ForwardGroup"
    forward_group_config {
      server_group_tuples {
        server_group_id = alicloud_alb_server_group.ecs.id
        weight          = 100
      }
    }
  }

  tags = var.tags
}
