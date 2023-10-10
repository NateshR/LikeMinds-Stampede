resource "kubernetes_deployment" "caravan-rabbitmq-load" {
  count = var.enable_caravan_rabbitmq ? 1 : 0

  metadata {
    name = var.caravan_rabbitmq_app_name
    namespace = var.namespace_name
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
          port {
            container_port = 5672
          }
          port {
            container_port = 15672
          }
          env {
            name = "RABBITMQ_DEFAULT_USER"
            value_from {
              secret_key_ref {
                name = "rabbitmq-user-secret"
                key = "username"
              }
            }
          }
          env {
            name = "RABBITMQ_DEFAULT_PASS"
            value_from {
              secret_key_ref {
                name = "rabbitmq-user-secret"
                key = "password"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "caravan-rabbitmq-load" {
  count = var.enable_caravan_rabbitmq ? 1 : 0

  metadata {
    name = var.caravan_rabbitmq_app_name
    namespace = var.namespace_name
    annotations = {
      "cloud.google.com/neg": "{\"ingress\": true}"
    }
  }
  spec {
    selector = {
      app = var.caravan_rabbitmq_app_name
    }
    port {
      name = "http"
      port        = 15672
      target_port = 15672
    }
    port {
      name = "amqp"
      port = 5672
      target_port = 5672
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "caravan-rabbitmq-load" {
  count = var.enable_caravan_rabbitmq ? 1 : 0
  
  metadata {
    name = var.caravan_rabbitmq_app_name
    namespace = var.namespace_name
    annotations = {
      "kubernetes.io/ingress.class": "gce"
      "kubernetes.io/ingress.allow-http": "true"
      "kubernetes.io/ingress.global-static-ip-name": "caravan-rabbitmq-load-testing-static-ip"
    }
  }

  spec {
    rule {
      http {
        path {
          backend {
            service {
              name = var.caravan_rabbitmq_app_name
              port {
                number = 15672
              }
            }
          }

          path = "/"
        }
      }
    }
  }
}

resource "kubernetes_secret_v1" "rabbitmq-user-secret" {
  metadata {
    name = "rabbitmq-user-secret"
    namespace = var.namespace_name
  }

  data = {
    username = "caravan-celery-load-user"
    password = "caravan-celery-load-user-password"
  }

}
