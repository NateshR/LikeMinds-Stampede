resource "kubernetes_secret_v1" "caravan-celery-secret" {
  count = var.enable_caravan ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load]
  
  metadata {
    name = "caravan-celery-secret"
    namespace = var.namespace_name
  }

  data = {
    CELERY_BROKER_URL = var.caravan_celery_broker_url
  }

}

resource "kubernetes_deployment" "caravan-celery-load" {
  count = var.enable_caravan ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load, kubernetes_secret_v1.caravan-celery-secret]

  metadata {
    name = var.caravan_celery_app_name
    namespace = var.namespace_name
    labels = {
      app = var.caravan_celery_app_name
    }
  }

  spec {
    replicas = var.caravan_celery_pods

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
              cpu    = var.caravan_celery_cpu
              memory = var.caravan_celery_memory
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
  count = var.enable_caravan ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load]
  
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
