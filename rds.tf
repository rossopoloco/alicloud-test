RDS for PostgreSQL
resource "alicloud_db_instance" "pg" {
  engine           = "PostgreSQL"
  engine_version   = local.cfg.pg_engine_ver
  instance_type    = local.cfg.pg_class
  db_instance_storage = local.cfg.pg_storage_gb
  instance_charge_type = "PostPaid"    # 先按量，跑通后可包年包月
  vswitch_id       = alicloud_vswitch.main.id
  security_ips     = ["0.0.0.0/0"]     # Test先开，Prod请收口为内网网段
基础/高可用
  category         = local.cfg.pg_edition  # "Basic" or "HighAvailability"
自动备份策略（可按需调整）
  maintain_time    = "01:00Z-02:00Z"
}
数据库与账号
resource "alicloud_db_database" "pgdb" {
  instance_id = alicloud_db_instance.pg.id
  name        = "appdb"
  character_set_name = "UTF8"
}
resource "alicloud_db_account" "pguser" {
  instance_id = alicloud_db_instance.pg.id
  name        = "appuser"
  password    = "ChangeMe_123!"  # 改成 TFC Sensitive 变量更安全
  type        = "Normal"
}
resource "alicloud_db_account_privilege" "pggrant" {
  instance_id  = alicloud_db_instance.pg.id
  account_name = alicloud_db_account.pguser.name
  db_name      = alicloud_db_database.pgdb.name
  privilege    = "ReadWrite"
}