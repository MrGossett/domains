module "redirect-0" {
  source        = "./modules/redirector"
  src_domain    = "${element(keys(var.domains), 0)}"
  target_domain = "${var.target_domain}"
}

module "redirect-1" {
  source        = "./modules/redirector"
  src_domain    = "${element(keys(var.domains), 1)}"
  target_domain = "${var.target_domain}"
}

module "redirect-2" {
  source        = "./modules/redirector"
  src_domain    = "${element(keys(var.domains), 2)}"
  target_domain = "${var.target_domain}"
}

module "redirect-3" {
  source        = "./modules/redirector"
  src_domain    = "${element(keys(var.domains), 3)}"
  target_domain = "${var.target_domain}"
}
