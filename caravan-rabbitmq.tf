resource "kubernetes_secret_v1" "rabbitmq-user-secret" {
  count = var.enable_caravan ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load]
  
  metadata {
    name = "rabbitmq-user-secret"
    namespace = var.namespace_name
  }

  data = {
    username = var.caravan_rabbitmq_username
    password = var.caravan_rabbitmq_password
  }

}

resource "kubernetes_deployment" "caravan-rabbitmq-load" {
  count = var.enable_caravan ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load, kubernetes_secret_v1.rabbitmq-user-secret]

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
            container_port = local.http_port_5672
          }
          port {
            container_port = local.http_port_15672
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
  count = var.enable_caravan ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load]

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
      name = local.http_port_service
      port        = local.http_port_15672
      target_port = local.http_port_15672
    }
    port {
      name = local.amqp_port_service
      port = local.http_port_5672
      target_port = local.http_port_5672
    }
    type = local.type_cluster_ip
  }
}

resource "kubernetes_ingress_v1" "caravan-rabbitmq-load" {
  count = var.enable_caravan ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load]
  
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
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = var.caravan_rabbitmq_app_name
              port {
                number = local.http_port_15672
              }
            }
          }
        }
      }
    }
  }
}
