terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.11.0"
    }
  }
}

provider "vault" {
  address      = "https://vault.ndl.thomasgouveia.fr:8200"
  ca_cert_file = "../ca.crt"
  token        = var.vault_token
}
