terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.6.2"
    }
  }
}

# Configure kubernetes provider with Oauth2 access token.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config
# This fetches a new token, which will expire in 1 hour.
data "google_client_config" "default" {}

data "google_container_cluster" "likeminds-load-testing-autopilot-cluster" {
  name     = var.cluster_name
  location = var.region
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.likeminds-load-testing-autopilot-cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.likeminds-load-testing-autopilot-cluster.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_namespace" "app-deploy-load" {
  count = var.action == "apply" ? 1 : 0

  metadata {
    name = var.namespace_name
  }
}
