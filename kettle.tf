resource "kubernetes_deployment" "kettle-load" {
  count = var.enable_kettle ? 1 : 0

  metadata {
    name = var.kettle_app_name
    namespace = kubernetes_namespace.app-deploy-load.metadata.0.name
    labels = {
      app = var.kettle_app_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.kettle_app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.kettle_app_name
        }
      }

      spec {
        container {
          image = var.kettle_app_docker_image
          name  = var.kettle_app_name

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "kettle-load" {
  metadata {
    name = var.kettle_app_name
    namespace = var.namespace_name
  }
  spec {
    selector = {
      app = var.kettle_app_name
    }
    port {
      name = "http"
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}