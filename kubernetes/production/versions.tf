terraform {
  backend "gcs" {
    bucket = "tf-state-pdo-ndl-2022"
    prefix = "kubernetes/production/state"
  }
}

provider "google" {
  project = "pdo-ndl-2022"
  region  = "europe-west1"
}
