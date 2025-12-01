#################################
# WAF (按开关创建)
#################################

module "waf" {
  # 仅当打开开关时创建
  count   = var.enable_waf ? 1 : 0

  # 使用官方社区模块（基于阿里云 Terraform Provider）
  source  = "terraform-alicloud-modules/waf/alicloud"
  version = "1.1.0"

  # 只创建 WAF 实例（域名可后续再加）
  #create_waf_instance = true

  # 按你的命名规则与标签
  instance_name = "${var.name_prefix}-${var.env}-waf"
  tags          = local.tags

  # 规格：对应你表格里的 “WAF Enhancement100 QPS/Min”
  # 阿里云模块里常用的 package_code 示例有 version_1~version_5（不同区域略有差异）
  # 这里先用 version_3（常见对应增强 100 QPS），若你账号地域不支持，阿里云会报出可选值，按提示改这个值即可。
  package_code = "version_3"

  # ===== 可选：如需一次性把业务域名也挂上 WAF，再打开下面这个块 =====
  # domains = [
  #   {
  #     domain           = "app.yourdomain.com"
  #     protocol         = "HTTP"          # 或 "HTTPS"
  #     http_port        = "80"
  #     https_port       = "443"
  #     https_redirect   = false
  #     # 如果是 HTTPS，需要先把证书在阿里云证书中心/或 WAF 里准备好，并在这里填证书信息（参考模块 README）
  #   }
  # ]
}


