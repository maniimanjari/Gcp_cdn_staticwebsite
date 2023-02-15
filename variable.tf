variable "name" {
  description = "Name used for naming the load balancer resources"
  type    = string
}
variable "domain" {
  description = "a domain name for your managed SSL certificate"
  type    = string
}
variable "project_id" {
  description = "GCP project ID"
  type    = string
}
variable "region" {
  description = "GCP region"
  type    = string
}
variable "location" {
  description = "GCP location"
  type    = string
}
variable "IP_address" {
  description = "Reserved external IP address of the LB "
  type    = string
}
variable "Environment" {
  description = "Name of the environment to be Dev or Production where the static files reside "
  type    = string
}
variable "packageDIR" {
  description = "External PackageDIR where files can be fetched"
  type        = string
  default     = ""
}
