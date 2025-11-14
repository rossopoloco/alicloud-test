找一张可用的官方 Linux 镜像
data "alicloud_images" "linux" {
  most_recent = true
  owners      = "system"
  os_type     = "linux"
}
resource "alicloud_instance" "web" {
  count                = local.cfg.ecs_count
  instance_name        = "
${var.env}-web-$
{count.index}"
  image_id             = data.alicloud_images.linux.images[0].id
  instance_type        = local.cfg.ecs_type
  vswitch_id           = alicloud_vswitch.main.id
  security_groups      = [alicloud_security_group.web.id]
  internet_max_bandwidth_out = 0 # 走 EIP；这里留 0
  system_disk_category = "cloud_essd"
  system_disk_size     = local.cfg.ecs_sys_disk_gb
初期允许密码（安全起见建议用 KeyPair）
  password             = "ChangeMe_123!"
}
EIP（Test 2Mbps）
resource "alicloud_eip" "pub" {
  bandwidth = local.cfg.eip_bandwidth
}
绑定 EIP 到第一台 ECS（Test）
resource "alicloud_eip_association" "pub_to_ecs0" {
  instance_id   = alicloud_instance.web[0].id
  allocation_id = alicloud_eip.pub.id
}