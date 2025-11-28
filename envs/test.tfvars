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
enable_waf           = false

# —— 切到 Windows 2025 —— 
ecs_image_id = "win2025_24H2_x64_dtc_en-us_40G_uefi_alibase_20251112.vhd"  # ← 用你复制的那个ID替换
ecs_password = "Strong.P@ssw0rd-2025!"                                 # 8–30位，至少三类字符
open_rdp     = true                                                    # 需要远程桌面就先开
