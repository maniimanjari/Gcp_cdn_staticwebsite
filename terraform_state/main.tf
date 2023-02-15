provider "google" {
  project = var.project_id
}

resource "google_storage_bucket" "terraform" {
  force_destroy = false

  cors {
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    max_age_seconds = 3600
  }

  location      = "US"
  name          = var.terraformstatebucket_name
  project       = var.project_id
  storage_class = "STANDARD"
}
