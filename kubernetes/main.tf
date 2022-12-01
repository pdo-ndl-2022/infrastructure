locals {
  project_id = "pdo-ndl-2022"
}

module "network" {
  source       = "terraform-google-modules/network/google"
  version      = ">= 4.0.1"
  project_id   = local.project_id
  network_name = "k8s-vpc"
  subnets = [
    {
      subnet_name   = "k8s-subnetwork"
      subnet_ip     = "10.0.0.0/17"
      subnet_region = "europe-west1"
    },
  ]

  secondary_ranges = {
    "k8s-subnetwork" = [
      {
        range_name    = "k8s-subnetwork-pods"
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = "k8s-subnetwork-services"
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}

module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google"
  project_id             = local.project_id
  name                   = "k8s-gke"
  regional               = true
  region                 = "europe-west1"
  network                = module.network.network_name
  subnetwork             = module.network.subnets_names[0]
  ip_range_pods          = "k8s-subnetwork-pods"
  ip_range_services      = "k8s-subnetwork-services"
  create_service_account = true

  node_pools = [

  ]
}

resource "helm_release" "cert_manager" {
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  name             = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    module.gke
  ]
}
