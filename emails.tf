module "domain" {
  source = "modules/email"

  domains    = "${keys(var.domains)}"
  txt_values = "${values(var.domains)}"
}
