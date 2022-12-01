module "gke" {
  source     = "terraform-google-modules/kubernetes-engine/google"
  project_id = "pdo-ndl-2022"
  name       = "production"
  region     = "europe-west1"
  zones      = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
  network    = "default"
  subnetwork = "default"
  # ip_range_pods              = "us-central1-01-gke-01-pods"
  # ip_range_services          = "us-central1-01-gke-01-services"
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

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
      pdo-node-pool = {
        pdo-node-pool = true
      }
    }
  }

  node_pools_metadata = {
    all = {}
  }

  node_pools_taints = {
    all = []
  }

  node_pools_tags = {
    all = []

    pdo-node-pool = [
      "pdo-node-pool",
    ]
  }
}
