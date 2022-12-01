resource "google_compute_network" "ndi" {
  name                    = "development-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "pdo_subnet" {
  name          = "dev-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = "europe-west1"
  network       = google_compute_network.ndi.id
}

resource "google_compute_subnetwork" "pdo_subnet_pods" {
  name          = "dev-subnet-pods"
  ip_cidr_range = "10.3.0.0/16"
  region        = "europe-west1"
  network       = google_compute_network.ndi.id
}

resource "google_compute_subnetwork" "pdo_subnet_services" {
  name          = "dev-subnet-services"
  ip_cidr_range = "10.4.0.0/16"
  region        = "europe-west1"
  network       = google_compute_network.ndi.id
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "pdo-ndl-2022"
  name                       = "development"
  region                     = "europe-west1"
  zones                      = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
  network                    = google_compute_network.ndi.name
  subnetwork                 = google_compute_subnetwork.pdo_subnet.name
  ip_range_pods              = google_compute_subnetwork.pdo_subnet_pods.name
  ip_range_services          = google_compute_subnetwork.pdo_subnet_services.name
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false

  node_pools = [
    {
      name               = "pdo-node-pool"
      machine_type       = "e2-medium"
      node_locations     = "europe-west1-b, europe-west1-b"
      min_count          = 1
      max_count          = 100
      local_ssd_count    = 0
      spot               = false
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = true
      service_account    = "project-service-account@pdo-ndl-2022.iam.gserviceaccount.com"
      preemptible        = false
      initial_node_count = 80
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
