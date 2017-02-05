resource "aws_ses_receipt_rule_set" "rs" {
  rule_set_name = "default-rule-set"
}

resource "aws_ses_active_receipt_rule_set" "rs" {
  rule_set_name = "${aws_ses_receipt_rule_set.rs.id}"
}

resource "aws_ses_receipt_rule" "forward" {
  name          = "forward"
  rule_set_name = "${aws_ses_active_receipt_rule_set.rs.id}"

  recipients = ["${keys(var.domains)}"]

  enabled      = true
  scan_enabled = true

  sns_action {
    topic_arn = "${var.sns_topic_arn}"
    position  = 0
  }
}
