resource "kubernetes_deployment" "caravan-celery-load" {
  count = var.enable_caravan_celery ? 1 : 0

  metadata {
    name = var.caravan_celery_app_name
    namespace = kubernetes_namespace.app-deploy-load.metadata.0.name
    labels = {
      app = var.caravan_celery_app_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.caravan_celery_app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.caravan_celery_app_name
        }
      }

      spec {
        container {
          image = var.caravan_celery_app_docker_image
          name  = var.caravan_celery_app_name

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

          env {
            name = "CELERY_BROKER_URL"
            value_from {
              secret_key_ref {
                name = "caravan-celery-secret"
                key = "CELERY_BROKER_URL"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "caravan-celery-load" {
  count = var.enable_caravan_celery ? 1 : 0
  
  metadata {
    name = var.caravan_celery_app_name
    namespace = var.namespace_name
    annotations = {
      "cloud.google.com/neg": "{\"ingress\": true}"
    }
  }
  spec {
    selector = {
      app = var.caravan_celery_app_name
    }
    port {
      name = "http"
      port        = 5672
      target_port = 5672
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "swarm-load" {
  count = var.enable_caravan_celery ? 1 : 0
  
  metadata {
    name = var.caravan_celery_app_name
    namespace = var.namespace_name
    annotations = {
      "kubernetes.io/ingress.class": "gce"
      "kubernetes.io/ingress.allow-http": "true"
      "kubernetes.io/ingress.global-static-ip-name": "likeminds-nonprod-caravan-celery-static-ip"
    }
  }

  spec {
    rule {
      http {
        path {
          backend {
            service {
              name = var.caravan_celery_app_name
              port {
                number = 5672
              }
            }
          }

          path = "/"
        }
      }
    }
  }
}
