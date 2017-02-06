data "aws_acm_certificate" "c" {
  domain = "${var.src_domain}"
}
