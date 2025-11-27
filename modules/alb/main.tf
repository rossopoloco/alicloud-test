# ALB（公网）
resource "alicloud_alb_load_balancer" "this" {
  load_balancer_name    = "${var.name_prefix}-${var.env}-alb"
  address_type          = "Internet"
  vpc_id                = var.vpc_id
  load_balancer_edition = "Standard"

  # 计费：按量
  load_balancer_billing_config {
    pay_type = "PayAsYouGo"
  }

  # 可用区映射
  zone_mappings {
    zone_id    = var.zone_id
    vswitch_id = var.vswitch_id
  }

  # 这里不再显式传 security_group_ids，避免“unsupported argument”
  #（如果你确实需要单独的 ALB 安全组，可后续再扩展模块）

  tags = merge(
    var.tags,
    {
      Project = var.name_prefix
      Env     = var.env
    }
  )
}

# 后端 server group（把后端 ECS 都加进去，端口用 alb_server_port）
resource "alicloud_alb_server_group" "ecs" {
  server_group_name = "${var.name_prefix}-${var.env}-alb-sg"
  vpc_id            = var.vpc_id
  protocol          = "HTTP"
  scheduler         = "Wrr"

  health_check_config {
    health_check_enabled     = true
    health_check_protocol    = "HTTP"
    health_check_method      = "GET"
    health_check_path        = "/"
    healthy_threshold        = 3
    unhealthy_threshold      = 3
    health_check_connect_port = var.alb_server_port
    health_check_interval    = 5
    health_check_timeout     = 3
  }

  # 把根模块传来的 ECS ID 动态加入
  dynamic "servers" {
    for_each = toset(var.backend_ecs_ids)
    content {
      server_id   = servers.value
      server_type = "Ecs"
      port        = var.alb_server_port
      weight      = 100
    }
  }

  tags = merge(
    var.tags,
    {
      Project = var.name_prefix
      Env     = var.env
    }
  )
}

# 监听器：HTTP 80（端口由变量控制）
resource "alicloud_alb_listener" "http" {
  listener_protocol = "HTTP"
  listener_port     = var.alb_listener_port
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

  tags = merge(
    var.tags,
    {
      Project = var.name_prefix
      Env     = var.env
    }
  )
}

output "alb_dns_name" {
  value       = alicloud_alb_load_balancer.this.dns_name
  description = "ALB 公网域名"
}
