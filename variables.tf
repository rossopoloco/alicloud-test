variable "region" {
  type    = string
  default = "cn-wulanchabu"
}
variable "env" {
  type    = string
  default = "test" # 先跑 test，之后 prod
}
locals {
分环境参数（可按你的表增改）
  settings = {
    test = {
      vpc_cidr        = "10.10.0.0/16"
      vsw_cidr        = "10.10.1.0/24"
      zone_id         = "cn-wulanchabu-a" # 按你的账号可用区改
      eip_bandwidth   = 2                 # Mbps
      ecs_count       = 1
      ecs_type        = "ecs.u1-c1m4.large" # 2c8g
      ecs_sys_disk_gb = 40
      oss_capacity_gb = 40
      pg_edition      = "Basic"          # 基础版
      pg_class        = "pg.n2.2c.1m"    # 2c ~4GiB
      pg_engine_ver   = "14"             # PG 17若不可选可用14/15
      pg_storage_gb   = 20
    }
    prod = {
      vpc_cidr        = "10.20.0.0/16"
      vsw_cidr        = "10.20.1.0/24"
      zone_id         = "cn-wulanchabu-a"
      eip_bandwidth   = 10
      ecs_count       = 2
      ecs_type        = "ecs.u1-c1m4.large"
      ecs_sys_disk_gb = 40
      oss_capacity_gb = 100
      pg_edition      = "HighAvailability"
      pg_class        = "pg.n4.2c.2m"    # 2c ~8GiB
      pg_engine_ver   = "14"
      pg_storage_gb   = 50
    }
  }
  cfg = local.settings[var.env]
}