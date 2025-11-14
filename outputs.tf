output "eip_address" {
  value = alicloud_eip.pub.ip_address
}
output "pg_endpoint" {
  value = alicloud_db_instance.pg.connection_string
}
output "oss_bucket" {
  value = alicloud_oss_bucket.main.bucket
}