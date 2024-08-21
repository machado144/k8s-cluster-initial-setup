resource "google_container_cluster" "primary" {
  name     = "${var.cluster_name}-${terraform.workspace}"
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  cluster_autoscaling {
    enabled = true

    auto_provisioning_defaults {
      service_account = google_service_account.cluster_sa.email

      management {
        auto_repair  = true
        auto_upgrade = true
      }

      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]

      boot_disk_kms_key = ""  # Optional, specify if you use a KMS key
      min_cpu_platform  = "Automatic"
    }

    resource_limits {
      resource_type = "cpu"
      minimum       = var.min_cpu
      maximum       = var.max_cpu
    }

    resource_limits {
      resource_type = "memory"
      minimum       = var.min_memory
      maximum       = var.max_memory
    }
  }

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}
