resource "alicloud_oss_bucket" "main" {
  bucket = "
${var.env}-app-bucket-$
{random_id.suffix.hex}"
  acl    = "private"
}
resource "random_id" "suffix" {
  byte_length = 3
}