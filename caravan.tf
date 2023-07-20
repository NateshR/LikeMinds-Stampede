resource "kubernetes_deployment" "caravan-load" {
  count = var.enable_caravan ? 1 : 0

  metadata {
    name = var.caravan_app_name
    namespace = kubernetes_namespace.app-deploy-load.metadata.0.name
    labels = {
      app = var.caravan_app_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.caravan_app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.caravan_app_name
        }
      }

      spec {
        container {
          image = var.caravan_app_docker_image
          name  = var.caravan_app_name

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

resource "kubernetes_service" "caravan-load" {
  metadata {
    name = var.caravan_app_name
    namespace = var.namespace_name
  }
  spec {
    selector = {
      app = var.caravan_app_name
    }
    port {
      name = "http"
      port        = 8081
      target_port = 8081
    }
    type = "ClusterIP"
  }
}
