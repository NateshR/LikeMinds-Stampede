resource "kubernetes_deployment" "kettle-load" {
  count = var.enable_kettle ? 1 : 0

  metadata {
    name      = var.kettle_app_name
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
    name      = var.kettle_app_name
    namespace = var.namespace_name
    annotations = {
      "cloud.google.com/neg": "{\"ingress\": true}"
    }
  }
  spec {
    selector = {
      app = var.kettle_app_name
    }
    port {
      name        = "http"
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress" "kettle-load" {
  metadata {
    name = var.kettle_app_name
    namespace = var.namespace_name
    annotations = {
      "kubernetes.io/ingress.class": "gce"
      "kubernetes.io/ingress.allow-http": "true"
      "kubernetes.io/ingress.global-static-ip-name": "likeminds-nonprod-caravan-celery-static-ip"
    }
  }

  spec {
    rule {
      host = "betaload.likeminds.community"
      http {
        path {
          backend {
            service_name = var.kettle_app_name
            service_port = 8080
          }

          path = "/"
          type = Prefix
        }
      }
    }

    tls {
      secret_name = "likeminds-app-deploy-secret"
    }
  }
}
