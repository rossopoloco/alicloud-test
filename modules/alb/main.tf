############################
# Application Load Balancer
############################

# ALB 专用安全组（仅放行 80/443，出方向默认放行）
resource "alicloud_security_group" "alb" {
  vpc_id              = var.vpc_id
  security_group_name = "${var.name_prefix}-${var.env}-alb-sg"
  tags                = var.tags
}

resource "alicloud_security_group_rule" "alb_ingress_http" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = alicloud_security_group.alb.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "alb_ingress_https" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 2
  security_group_id = alicloud_security_group.alb.id
  cidr_ip           = "0.0.0.0/0"
}

# 公网 ALB
resource "alicloud_alb_load_balancer" "this" {
  load_balancer_name    = "${var.name_prefix}-${var.env}-alb"
  address_type          = "Internet"
  vpc_id                = var.vpc_id
  security_group_ids    = [alicloud_security_group.alb.id]
  load_balancer_edition = "Standard"

  # 可用区与交换机映射
  zone_mappings {
    zone_id    = var.zone_id
    vswitch_id = var.vswitch_id
  }

  # 计费与带宽配置 —— 必须在这个子块里
  load_balancer_billing_config {
    pay_type                   = "PayAsYouGo"
    internet_charge_type       = "PayByTraffic"
    internet_max_bandwidth_out = var.bandwidth_mbps
  }

  tags = var.tags
}

# 后端 Server Group（把传入的 ECS 列表挂到 80 端口）
resource "alicloud_alb_server_group" "ecs" {
  server_group_name = "${var.name_prefix}-${var.env}-alb-sg"
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

# 监听器（HTTP : var.listener_port）-> 转发到上一组
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

#output "alb_dns_name" {
#  value       = alicloud_alb_load_balancer.this.dns_name
#  description = "ALB 公网域名（测试用）"
#}
