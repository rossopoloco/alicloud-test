variable "name_prefix" { type = string }
variable "env"         { type = string }

variable "vpc_id"     { type = string }
variable "zone_id"    { type = string }
variable "vswitch_id" { type = string }

variable "listener_port" {
  type    = number
  default = 80
}

variable "backend_port" {
  type    = number
  default = 80
}

variable "backend_instance_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
