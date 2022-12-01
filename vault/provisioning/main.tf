resource "vault_mount" "pki" {
  path = "interca"
  type = "pki"
}

data "terraform_remote_state" "gke" {
  backend = "gcs"

  config = {
    bucket = "tf-state-ndl-2022"
    prefix = "kubernetes/state"
  }
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}


resource "vault_kubernetes_auth_backend_config" "k8s" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = data.terraform_remote_state.gke.outputs.k8s_endpoint
  kubernetes_ca_cert     = data.terraform_remote_state.gke.outputs.k8s_cluster_ca_certificate
  issuer                 = "api"
  disable_iss_validation = "true"
}
