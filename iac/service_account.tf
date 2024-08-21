resource "google_service_account" "cluster_sa" {
  account_id   = "cluster-service-account"
  display_name = "Cluster Service Account"
}

resource "google_project_iam_member" "sa_artifact_registry_access" {
  project = var.project_id
  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.cluster_sa.email}"
}

resource "google_project_iam_member" "sa_storage_access" {
  project = var.project_id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cluster_sa.email}"
}

resource "google_project_iam_member" "sa_logging_access" {
  project = var.project_id
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.cluster_sa.email}"
}

resource "google_project_iam_member" "sa_monitoring_access" {
  project = var.project_id
  role   = "roles/monitoring.metricWriter"
  member = "serviceAccount:${google_service_account.cluster_sa.email}"
}
