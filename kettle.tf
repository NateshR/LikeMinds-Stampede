resource "kubernetes_deployment" "kettle-load" {
  count = var.enable_kettle ? 1 : 0

  metadata {
    name      = var.kettle_app_name
    namespace = var.namespace_name
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
              cpu    = var.kettle_cpu
              memory = var.kettle_memory
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "kettle-load" {
  count = var.enable_kettle ? 1 : 0

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

resource "kubernetes_ingress_v1" "kettle-load" {
  count = var.enable_kettle ? 1 : 0
  
  metadata {
    name = var.kettle_app_name
    namespace = var.namespace_name
    annotations = {
      "kubernetes.io/ingress.class": "gce"
      "kubernetes.io/ingress.allow-http": "true"
      "kubernetes.io/ingress.global-static-ip-name": "kettle-load-testing-static-ip"
    }
  }

  spec {
    rule {
      host = "kettle-load.likeminds.community"
      http {
        path {
          backend {
            service {
              name = var.kettle_app_name
              port {
                number = 8080
              }
            }
          }

          path = "/"
        }
      }
    }
  }
}
