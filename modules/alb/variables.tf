variable "name_prefix" {
  type = string
}

variable "env" {
  type = string
}

# 基础网络
variable "vpc_id" {
  type = string
}

variable "vswitch_id" {
  type = string
}

variable "zone_id" {
  type = string
}

# ALB 参数
variable "alb_listener_port" {
  type    = number
  default = 80
}

variable "alb_server_port" {
  type    = number
  default = 80
}

variable "alb_bandwidth_mbps" {
  type    = number
  default = 10
}

# 后端 ECS 列表（由根模块传入）
variable "backend_ecs_ids" {
  type    = list(string)
  default = []
}

# 统一标签（由根模块传入）
variable "tags" {
  type    = map(string)
  default = {}
}
