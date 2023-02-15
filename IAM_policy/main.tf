provider "google" {
  project = var.project_id
}

variable "permissions"{
  description = "The permissions to set"
  type        = list(any)
  default =  [
    "storage.admin",
    "compute.loadBalancerAdmin"
  ]
}

locals {
  set_permissions = {
  for p in setproduct(var.members, var.permissions) : "${p[0]}/${p[1]}" => {
    member    = p[0]
    permission  = p[1]
  }
  }
}

resource "google_compute_global_address" "default" {
  name = "external-ip-address"
}

resource "google_project_iam_member" "storage_admin" {
  for_each = local.set_permissions
  project = var.project_id
  role = "roles/${each.value.permission}"
  member = "user:${each.value.member}@west.com"
}

output "load_balancer_ip" {
  value = google_compute_global_address.default.address
}
