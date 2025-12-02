#resource "alicloud_oss_bucket" "this" {
#  bucket = "${var.name_prefix}-${var.env}-${random_pet.suffix.id}"
#  storage_class = "Standard"
#  redundancy_type = var.oss_redundancy_type   # 关键：LRS / ZRS

#  tags = local.tags
#}

## 示例生命周期（把 30 天未访问的对象转IA，可按需调整）
#resource "alicloud_oss_bucket_lifecycle" "this" {
#  bucket = alicloud_oss_bucket.this.id

#  rule {
#    id      = "to-ia-after-30d"
#    enabled = true
#    transition {
#      days          = 30
#      storage_class = "IA"
#    }
#  }
#}



