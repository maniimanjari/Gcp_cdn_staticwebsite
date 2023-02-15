provider "google" {
  project = var.project_id
  region  = var.region
}
resource "google_storage_bucket" "default" {
  force_destroy = false

  cors {
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    max_age_seconds = 3600
  }

  location      = "${var.location}"
  name          = "${var.name}-bucket"
  project       = var.project_id
  storage_class = "STANDARD"
}
resource "google_compute_managed_ssl_certificate" "default" {
  provider = google

  name = "${var.name}-cert"
  managed {
    domains = [
      var.domain]
  }
}
resource "google_compute_backend_bucket" "default" {
  name        = "${var.name}-backend"
  bucket_name = google_storage_bucket.default.name
  enable_cdn  = true
}

resource "google_compute_url_map" "default" {
  name = "${var.name}-lb"
  default_service = google_compute_backend_bucket.default.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "path-matcher-1"
  }

  path_matcher {
    name            = "path-matcher-1"
    default_service = google_compute_backend_bucket.default.id

    path_rule {
      paths = ["/*"]

      route_action {
        url_rewrite {
          path_prefix_rewrite = "/${var.Environment}/"
        }
      }

      service = google_compute_backend_bucket.default.id
    }
  }

  project = var.project_id
}

resource "google_compute_target_https_proxy" "default" {
  name   = "${var.name}-https-proxy"

  url_map          = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.default.id
  ]
}

resource "google_compute_global_forwarding_rule" "default" {
  name   = "${var.name}-urlmap"

  target = google_compute_target_https_proxy.default.id
  port_range = "443"
  ip_address = var.IP_address
}

resource "google_storage_bucket_object" "gcp_static" {
  name     = "${var.Environment}/gcc_installer/${var.packageDIR}"
  source   = "${each.value.source_dir}/${var.packageDIR}"
  bucket   = google_storage_bucket.default.name
}

resource "google_storage_object_acl" "gcp_static_acl" {
  bucket = google_storage_bucket.default.name
  object = "static-${var.Environment}/gcc_installer/${var.packageDIR}"

  role_entity = [
    "READER:allUsers",
  ]
  depends_on = [
    google_storage_bucket_object.gcp_static,
  ]
}
resource "null_resource" "Slack_notify" {
  for_each = merge(local.projects_in_folder1, local.projects_in_folder2)
  provisioner "local-exec" {
      command = <<-EOT
          curl -X POST 'https://api.slack-example-url.com/v1/messages' -H 'Authorization: Bearer xyz" ${var.packageDIR} files uploaded to GCP Bucket" }'
  EOT
    }
  depends_on = [
    google_storage_bucket_object.gcp_static,
  ]
}