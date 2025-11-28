env                  = "prod"
name_prefix          = "wu-prod"
vpc_cidr             = "10.40.0.0/16"
vsw_cidr             = "10.40.1.0/24"

ecs_instance_count   = 2
eip_bandwidth_mbps   = 10

oss_redundancy_type = "ZRS"   # 对应表里的 “Standard region storage”

pg_instance_class    = "pg.n4.2c.2m" # 17 HA
pg_storage_gib       = 100

enable_alb           = true
enable_waf           = true


