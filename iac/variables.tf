variable "project_id" {
  description = "The project ID where resources will be created."
}

variable "region" {
  description = "The region to deploy resources."
  default     = "us-central1"
}

variable "zone" {
  description = "The zone to deploy resources."
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  default     = "my-cluster"
}

variable "gcs_bucket" {
  description = "The GCS bucket for storing Terraform state."
}

variable "min_cpu" {
  description = "Minimum number of CPUs for Node Auto-Provisioning."
  default     = 1
}

variable "max_cpu" {
  description = "Maximum number of CPUs for Node Auto-Provisioning."
  default     = 40
}

variable "min_memory" {
  description = "Minimum memory in MB for Node Auto-Provisioning."
  default     = 1024
}

variable "max_memory" {
  description = "Maximum memory in MB for Node Auto-Provisioning."
  default     = 65536
}

variable "machine_type" {
  description = "Default machine type for NAP node pools."
  default     = "e2-medium"
}
