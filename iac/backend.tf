terraform {
  backend "gcs" {
    bucket  = "poc-infra-resource-states"
    prefix  = "terraform/state"
  }
}
