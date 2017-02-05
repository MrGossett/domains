resource "aws_acm_certificate" "c" {
  domain_name = "${var.src_domain}"

  subject_alternative_names = ["*.${var.src_domain}"]

  tags = [
    {
      key   = "Name"
      value = "Root Domain Certificate for ${var.src_domain}"
    },
  ]
}
