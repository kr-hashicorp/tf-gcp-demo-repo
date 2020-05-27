provider "google" {
  version = "3.5.0"
  # A GCP service account key: Terraform will access your GCP account by using a service account key.
  credentials = file("<NAME>.json")
  # A GCP Project: GCP organizes resources into projects.  
  project = "<PROJECT_ID>"
  region  = "us-central1"
  zone    = "us-central1-c"
  /*
  Note: Be sure to replace <NAME> with the name of the service account key file, and <PROJECT_ID> with your project's ID.
  */
}

# Google Compute Engine: You'll need to enable Google Compute Engine for your project.
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
