terraform {
  backend "gcs" {
    bucket  = "$GCP_STATE_BUCKET"
    prefix  = "terraform/states/gke"
  }
}
