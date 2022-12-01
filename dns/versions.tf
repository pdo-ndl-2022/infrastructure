terraform {
  backend "gcs" {
    bucket = "tf-state-ndl-2022"
    prefix = "dns/state"
  }
}

provider "google" {
  project = "pdo-ndl-2022"
  region  = "europe-west1"
}
