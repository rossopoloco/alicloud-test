output "dns_name" {
  value       = alicloud_alb_load_balancer.this.dns_name
  description = "ALB 公网域名"
}
