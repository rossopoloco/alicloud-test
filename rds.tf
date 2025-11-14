# PostgreSQL 实例
resource "alicloud_db_instance" "pg" {
  engine           = "PostgreSQL"
  engine_version   = var.pg_engine_version
  instance_type    = var.pg_instance_class
  instance_storage = var.pg_storage_gib

  vswitch_id = alicloud_vswitch.this.id
  security_ips = [
    alicloud_vpc.this.cidr_block
  ]

  instance_name = "${var.name_prefix}-${var.env}-pg"
  pay_type      = "Postpaid"

  # test 选 Basic, prod 可切到 HighAvailability
  db_instance_storage_type = "cloud_essd"

  tags = local.tags
}

# 一个示例数据库和账号
resource "alicloud_rds_account" "pgadmin" {
  db_instance_id   = alicloud_db_instance.pg.id
  account_name     = "pgadmin"
  account_password = "P@ssw0rd-ChangeMe"
}

resource "alicloud_rds_database" "app" {
  instance_id = alicloud_db_instance.pg.id
  name        = "appdb"
  character_set_name = "UTF8"
}
