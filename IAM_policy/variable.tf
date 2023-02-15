variable "project_id" {
  description = "GCP project ID"
  type    = string
  default = "cc-hoot-branding-dev-01"
}
variable "members" {
  description = "The prefix of e-mail id"
  type        = list(any)
}