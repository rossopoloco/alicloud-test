variable "region" {
  type        = string
  description = "Region id, e.g. cn-wulanchabu"
  default     = "cn-wulanchabu"
}

variable "env" {
  type        = string
  description = "Environment name: test | prod"
}

variable "name_prefix" {
  type        = string
  description = "Resource name prefix"
  default     = "demo"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.20.0.0/16"
}

variable "vsw_cidr" {
  type        = string
  default     = "10.20.1.0/24"
}

variable "eip_bandwidth_mbps" {
  type        = number
  description = "Public EIP bandwidth cap"
  default     = 2
}

# ECS
variable "ecs_instance_count" {
  type = number
  default = 1
}

variable "ecs_instance_type" {
  type        = string
  # 你表里的：ecs.u1-c1m4.large  (2vCPU/8GiB)
  default     = "ecs.u1-c1m4.large"
}

variable "ecs_image_id" {
  type        = string
  description = "Image id; empty to use latest Ubuntu 22.04"
  default     = ""
}

# OSS
variable "oss_redundancy_type" {
  type        = string
  description = "OSS 冗余类型：LRS(本地) 或 ZRS(区域)"
  default     = "LRS"
}

# RDS PostgreSQL
variable "pg_engine_version" {
  type    = string
  default = "17"
}

variable "pg_instance_class" {
  type        = string
  description = "规格，如 pg.n2.2c.1m / pg.n4.2c.2m"
  default     = "pg.n2.2c.1m"
}

variable "pg_storage_gib" {
  type    = number
  default = 20
}

# ALB
variable "enable_alb" {
  type    = bool
  default = false
}

variable "alb_bandwidth_mbps" {
  type    = number
  default = 10
}

variable "alb_listener_port" {
  type    = number
  default = 80
}

# WAF（占位）
variable "enable_waf" {
  type    = bool
  default = false
}


