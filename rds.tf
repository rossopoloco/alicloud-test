# PostgreSQL 实例
resource "alicloud_db_instance" "pg" {
  engine                 = "PostgreSQL"
  engine_version         = var.pg_engine_version
  instance_type          = var.pg_instance_class
  instance_storage       = var.pg_storage_gib
  vswitch_id             = alicloud_vswitch.this.id
  security_ips           = [alicloud_vpc.this.cidr_block]
  instance_name          = "${var.name_prefix}-${var.env}-pg"
  db_instance_storage_type = "cloud_essd"
  
  # 计费：PostPaid(按量) / PrePaid(包年包月)
  instance_charge_type = var.pg_charge_type

  # 仅当 PrePaid 时生效；PostPaid 时 provider 忽略（或用三元置 null 亦可）
  period       = var.pg_charge_type == "PrePaid" ? var.pg_period : null   # 月数：1~9,12,24,36
  auto_renew   = var.pg_charge_type == "PrePaid" ? var.pg_auto_renew : null
  # （可选）配合 auto_renew 时使用
  auto_renew_period = var.pg_charge_type == "PrePaid" ? var.pg_auto_renew_period : null

  tags = local.tags
}

# 账号 —— rds -> db
resource "alicloud_db_account" "pgadmin" {
  db_instance_id      = alicloud_db_instance.pg.id
  account_name     = "pgadmin"
  account_password = "P@ssw0rd-ChangeMe"
}

# 数据库 —— rds -> db
# 注意：老字段 character_set_name 已不推荐，直接去掉或用 character_set。
resource "alicloud_db_database" "app" {
  instance_id   = alicloud_db_instance.pg.id
  name          = "appdb"
  # PostgreSQL 通常用 UTF8，若需要显式指定，用下面这一行；不需要可以删掉
  # character_set = "UTF8"
}




