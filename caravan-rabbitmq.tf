resource "kubernetes_deployment" "caravan-rabbitmq-load" {
  count = var.enable_caravan_rabbitmq ? 1 : 0

  metadata {
    name = var.caravan_rabbitmq_app_name
    namespace = kubernetes_namespace.app-deploy-load.metadata.0.name
    labels = {
      app = var.caravan_rabbitmq_app_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.caravan_rabbitmq_app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.caravan_rabbitmq_app_name
        }
      }

      spec {
        container {
          image = var.caravan_rabbitmq_app_docker_image
          name  = var.caravan_rabbitmq_app_name
          ports {
            container_port = 5672
          }

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

resource "kubernetes_service" "caravan-rabbitmq-load" {
  metadata {
    name = var.caravan_rabbitmq_app_name
    namespace = var.namespace_name
  }
  spec {
    selector = {
      app = var.caravan_rabbitmq_app_name
    }
    port {
      name = "http"
      port        = 5672
      target_port = 5672
    }
    type = "ClusterIP"
  }
}
