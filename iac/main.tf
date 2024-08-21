provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_service_account" "cluster_sa" {
  account_id   = "cluster-service-account"
  display_name = "Cluster Service Account"
}

resource "google_compute_network" "vpc" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_container_cluster" "primary" {
  name     = "${var.cluster_name}-${terraform.workspace}"
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  cluster_autoscaling {
    enabled = true

    auto_provisioning_defaults {
      service_account = google_service_account.cluster_sa.email

      # To enable preemptible VMs and set other defaults
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

  # Specify network configurations
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}
