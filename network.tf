resource "alicloud_vpc" "this" {
  vpc_name   = "${var.name_prefix}-${var.env}-vpc"
  cidr_block = var.vpc_cidr
  tags       = local.tags
}

resource "alicloud_vswitch" "this" {
  vswitch_name = "${var.name_prefix}-${var.env}-vsw-a"
  cidr_block   = var.vsw_cidr
  zone_id      = data.alicloud_zones.this.zones[0].id
  vpc_id       = alicloud_vpc.this.id
  tags         = local.tags
}

resource "alicloud_security_group" "this" {
  security_group_name = "${var.name_prefix}-${var.env}-sg"
  vpc_id = alicloud_vpc.this.id
  tags   = local.tags
}

# 允许 SSH 和 HTTP/HTTPS
resource "alicloud_security_group_rule" "ingress_ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.this.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "ingress_web" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/443"
  priority          = 2
  security_group_id = alicloud_security_group.this.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "ingress_rdp" {
  count             = var.open_rdp ? 1 : 0
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "3389/3389"
  priority          = 3
  security_group_id = alicloud_security_group.this.id
  cidr_ip           = "0.0.0.0/0"   # 生产建议收窄到公司出口IP段
}

# EIP（公网出口）
#resource "alicloud_eip_address" "this" {
#  address_name = "${var.name_prefix}-${var.env}-eip"
#  bandwidth    = var.eip_bandwidth_mbps
#  internet_charge_type = "PayByTraffic"
#  tags = local.tags
#}



