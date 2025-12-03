env                  = "test"
name_prefix          = "wu-test"
vpc_cidr             = "10.30.0.0/16"
vsw_cidr             = "10.30.1.0/24"

ecs_instance_count   = 1
ecs_charge_type     = "PrePaid"
ecs_period          = 14
ecs_period_unit     = "Month"
ecs_auto_renew      = false
ecs_auto_renew_period = 1

enable_eip = true
eip_bandwidth_mbps   = 2

oss_redundancy_type = "LRS"   # 对应表里的 “Standard local storage”

pg_instance_class    = "pg.n2.2c.1m" # 17 basic
pg_storage_gib       = 20


pg_category        = "Basic"       # 基础版
pg_charge_type     = "PrePaid"     # 包年
pg_period          = 14            # 1年（支持 1~9,12,24,36 月）
pg_auto_renew      = false
pg_auto_renew_period = 1

enable_alb           = false
enable_waf           = false

# —— 切到 Windows 2025 —— 
ecs_image_id = "win2025_24H2_x64_dtc_en-us_40G_uefi_alibase_20251112.vhd"  # ← 用你复制的那个ID替换
ecs_password = "Strong.P@ssw0rd-2025!"                                 # 8–30位，至少三类字符
open_rdp     = false                                                    # 需要远程桌面就先开
