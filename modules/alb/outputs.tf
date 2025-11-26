output "alb_dns_name" {
  value       = alicloud_alb_load_balancer.this.dns_name
  description = "ALB 公网域名"
}

output "alb_id" {
  value = alicloud_alb_load_balancer.this.id
}
