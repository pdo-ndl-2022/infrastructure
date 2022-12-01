resource "google_dns_managed_zone" "ndl" {
  name     = "ndl-zone"
  dns_name = "ndl.thomasgouveia.fr."
}
