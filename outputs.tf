output "eip" {
  value = try(alicloud_eip_address.this[0].ip_address, null)
}

output "ecs_private_ips" {
  value = [for i in alicloud_instance.ecs : i.private_ip]
}

output "oss_bucket" {
  value = alicloud_oss_bucket.this.bucket
}

output "pg_endpoint" {
  value = alicloud_db_instance.pg.connection_string
}
