variable "name" {
  type        = string
  description = "ALB name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vswitch_id" {
  type        = string
  description = "VSwitch ID for ALB zone mapping"
}

variable "zone_id" {
  type        = string
  description = "Zone ID (e.g., cn-wulanchabu-a)"
}

variable "alb_sg_id" {
  type        = string
  description = "Security Group ID used by ALB"
}

variable "server_instance_ids" {
  type        = list(string)
  default     = []
  description = "ECS instance IDs to register in ALB server group"
}

variable "listener_port" {
  type        = number
  default     = 80
  description = "ALB listener port"
}

variable "tags" {
  type        = map(string)
  default     = {}
}
