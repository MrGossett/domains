resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "Origin access identity for ${var.src_domain}"
}

resource "aws_cloudfront_distribution" "cf" {
  origin {
    domain_name = "${aws_s3_bucket.b.bucket_domain_name}"
    origin_id   = "${aws_s3_bucket.b.id}-bucket"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  comment             = "Cloudfront distribution for ${var.src_domain}"
  default_root_object = ""

  aliases = ["${var.src_domain}", "www.${var.src_domain}"]

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true
    target_origin_id = "${aws_s3_bucket.b.id}-bucket"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = "604800"
    default_ttl            = "604800"
    max_ttl                = "604800"
  }

  price_class = "PriceClass_200" # https://aws.amazon.com/cloudfront/pricing/

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate.c.arn}"
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }
}
