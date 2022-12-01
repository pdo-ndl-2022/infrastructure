terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.44.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  backend "gcs" {
    bucket = "tf-state-ndl-2022"
    prefix = "cloud-sql/state"
  }
}

provider "google" {
  project = "pdo-ndl-2022"
  region  = "europe-west1"
}
