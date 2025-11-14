resource "alicloud_vpc" "main" {
  vpc_name   = "${var.env}-vpc"
  cidr_block = local.cfg.vpc_cidr
}
resource "alicloud_vswitch" "main" {
  vswitch_name = "${var.env}-vsw-a"
  vpc_id       = alicloud_vpc.main.id
  cidr_block   = local.cfg.vsw_cidr
  zone_id      = local.cfg.zone_id
}
resource "alicloud_security_group" "web" {
  name        = "${var.env}-sg-web"
  vpc_id      = alicloud_vpc.main.id
  description = "web sg"
}
80/443 放行（Test 先放通，Prod 再收口）
resource "alicloud_security_group_rule" "web_http" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = alicloud_security_group.web.id
  cidr_ip           = "0.0.0.0/0"
}
resource "alicloud_security_group_rule" "web_https" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 2
  security_group_id = alicloud_security_group.web.id
  cidr_ip           = "0.0.0.0/0"
}
出站全开（按需收口）
resource "alicloud_security_group_rule" "egress_all" {
  type              = "egress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 100
  security_group_id = alicloud_security_group.web.id
  cidr_ip           = "0.0.0.0/0"
}