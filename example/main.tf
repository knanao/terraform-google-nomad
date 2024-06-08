variable "project" {
  description = "The GCP project name to deploy the cluster to."
}

variable "credentials" {
  description = "The GCP credentials file path to use, preferably a Terraform Service Account."
}

module "nomad" {
  source                        = "picatz/nomad/google"
  version                       = "2.7.8"
  project                       = var.project
  credentials                   = var.credentials
  bastion_enabled               = true
  server_instances              = 3
  client_instances              = 3
  grafana_load_balancer_enabled = true
  // dns_enabled                       = true
  // dns_managed_zone_dns_name         = "nomad.knanao.com"
  // grafana_dns_managed_zone_dns_name = "grafana.knanao.com"
}
