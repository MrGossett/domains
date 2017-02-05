resource "aws_route53_zone" "z" {
  count = "${length(var.domains)}"
  name  = "${element(var.domains, count.index)}"
}

resource "aws_route53_record" "mx" {
  count   = "${length(var.domains)}"
  zone_id = "${element(aws_route53_zone.z.*.id, count.index)}"
  name    = ""
  type    = "MX"
  records = ["10 inbound-smtp.us-east-1.amazonaws.com"]
  ttl     = 3600
}

resource "aws_route53_record" "txt" {
  count   = "${length(var.domains)}"
  zone_id = "${element(aws_route53_zone.z.*.id, count.index)}"
  name    = "_amazonses"
  type    = "TXT"
  records = ["${element(var.txt_values, count.index)}"]
  ttl     = 3600
}
