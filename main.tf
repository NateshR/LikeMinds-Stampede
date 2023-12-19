terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.20.0"
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
  metadata {
    name = var.namespace_name
  }
}

resource "kubernetes_secret_v1" "app-deploy-load-secret" {
  depends_on = [kubernetes_namespace.app-deploy-load]
  
  metadata {
    name = "app-deploy-load-secret"
    namespace = var.namespace_name
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = base64decode(var.tls_crt)
    "tls.key" = base64decode(var.tls_key)
  }

}

locals {
  http_port_service = "http" 
  amqp_port_service = "amqp"
  http_port_8080 = 8080
  http_port_8081 = 8081
  http_port_15672 = 15672
  http_port_5672 = 5672
  type_cluster_ip = "ClusterIP"
}
