env                  = "test"
name_prefix          = "wu-test"
vpc_cidr             = "10.30.0.0/16"
vsw_cidr             = "10.30.1.0/24"

ecs_instance_count   = 1
eip_bandwidth_mbps   = 2

oss_redundancy_type = "LRS"   # 对应表里的 “Standard local storage”

pg_instance_class    = "pg.n2.2c.1m" # 17 basic
pg_storage_gib       = 20

enable_alb           = false
