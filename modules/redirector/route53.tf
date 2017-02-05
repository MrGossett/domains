data "aws_route53_zone" "z" {
  name = "${var.src_domain}"
}

resource "aws_route53_record" "apex" {
  zone_id = "${data.aws_route53_zone.z.id}"
  name    = ""
  type    = "A"

  alias {
    name    = "${aws_cloudfront_distribution.cf.domain_name}"
    zone_id = "${aws_cloudfront_distribution.cf.hosted_zone_id}"

    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.z.id}"
  name    = "www"
  type    = "A"

  alias {
    name    = "${aws_cloudfront_distribution.cf.domain_name}"
    zone_id = "${aws_cloudfront_distribution.cf.hosted_zone_id}"

    evaluate_target_health = false
  }
}
