module "vault" {
  source         = "terraform-google-modules/vault/google"
  version        = "~> 6.2"
  project_id     = "pdo-ndl-2022"
  region         = "europe-west1"
  kms_keyring    = "vault-ndl"
  kms_crypto_key = "vault-ndl"
  domain         = "vault.ndl.thomasgouveia.fr"
  tls_dns_names  = ["vault.ndl.thomasgouveia.fr"]
}

resource "google_dns_record_set" "vault" {
  name         = "vault.ndl.thomasgouveia.fr."
  managed_zone = "ndl-zone"
  type         = "A"
  ttl          = 0
  rrdatas      = [module.vault.vault_lb_addr]
}

output "vault_addr" {
  value = module.vault.vault_addr
}
