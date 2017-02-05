resource "aws_s3_bucket" "b" {
  bucket = "${var.src_domain}"
  acl    = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["x-amz-meta-custom-header", "ETag"]
  }

  logging {
    target_bucket = "${var.src_domain}"
    target_prefix = "logs/"
  }

  lifecycle_rule {
    prefix  = "logs/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 90
    }
  }

  website {
    index_document = "html/index.html"

    routing_rules = <<EOF
[{
  "Redirect": {
    "ReplaceKeyWith": "",
    "HttpRedirectCode": "301",
    "HostName": "${var.target_domain}",
    "Protocol": "https"
  }
}]
EOF
  }
}

data "aws_iam_policy_document" "bucket" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.b.arn}/html/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.oai.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "bp" {
  bucket = "${var.src_domain}"
  policy = "${data.aws_iam_policy_document.bucket.json}"
}
