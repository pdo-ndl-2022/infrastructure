module "vault" {
  source         = "terraform-google-modules/vault/google"
  version        = "~> 6.2"
  project_id     = "pdo-ndl-2022"
  region         = "europe-west1"
  kms_keyring    = "vault-autounseal"
  kms_crypto_key = "vault-autounseal"
}
