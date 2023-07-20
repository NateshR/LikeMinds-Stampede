resource "kubernetes_deployment" "swarm-load" {
  count = var.enable_swarm ? 1 : 0

  metadata {
    name = var.swarm_app_name
    namespace = kubernetes_namespace.app-deploy-load.metadata.0.name
    labels = {
      app = var.swarm_app_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.swarm_app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.swarm_app_name
        }
      }

      spec {
        container {
          image = var.swarm_app_docker_image
          name  = var.swarm_app_name

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

resource "kubernetes_service" "swarm-load" {
  metadata {
    name = var.swarm_app_name
    namespace = var.namespace_name
  }
  spec {
    selector = {
      app = var.swarm_app_name
    }
    port {
      name = "http"
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}
