# 找一个常见镜像（如未指定）
data "alicloud_images" "ubuntu" {
  name_regex = "ubuntu_22.*64"
  most_recent = true
}

resource "random_pet" "suffix" {}

resource "alicloud_instance" "ecs" {
  count                      = var.ecs_instance_count
  instance_name              = "${var.name_prefix}-${var.env}-ecs-${count.index}-${random_pet.suffix.id}"
  password = var.ecs_password
  instance_type              = var.ecs_instance_type
  security_groups            = [alicloud_security_group.this.id]
  vswitch_id                 = alicloud_vswitch.this.id
  image_id                   = var.ecs_image_id != "" ? var.ecs_image_id : data.alicloud_images.ubuntu.images[0].id
  system_disk_category       = "cloud_essd"
  internet_max_bandwidth_out = 0 # 走 EIP 绑定 ENI 时设置 0

  tags = local.tags
}

# 将 EIP 绑定到第一台 ECS 的主 ENI（演示）
resource "alicloud_eip_association" "ecs0" {
  allocation_id = alicloud_eip_address.this.id
  instance_id   = alicloud_instance.ecs[0].id
}

