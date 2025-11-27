variable "name_prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vswitch_id" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "bandwidth_mbps" {
  type    = number
  default = 10
}

variable "listener_port" {
  type    = number
  default = 80
}

variable "server_instance_ids" {
  type        = list(string)
  description = "ECS 实例 ID 列表，将被挂到 ALB 后端组 80 端口"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "统一打到 ALB 相关资源上的标签"
  default     = {}
}
