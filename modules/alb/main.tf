############################
# Application Load Balancer
############################

# 公网 ALB（新版写法）
resource "alicloud_alb_load_balancer" "this" {
  load_balancer_name    = var.name
  address_type          = "Internet"
  load_balancer_edition = "Standard"
  vpc_id                = var.vpc_id
  security_group_ids    = [var.alb_sg_id]

  # 计费配置（新版需要）
  load_balancer_billing_config {
    pay_type = "PayAsYouGo"
    # 如果你要按带宽计费/限制，ALB 不像 SLB 那样在顶层加 bandwidth；
    # 需要付费档位另行配置，这里保持最简可用形态。
  }

  zone_mappings {
    zone_id    = var.zone_id
    vswitch_id = var.vswitch_id
  }

  tags = var.tags
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
