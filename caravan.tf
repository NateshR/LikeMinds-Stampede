resource "kubernetes_deployment" "caravan-load" {
  count = var.enable_caravan ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load]

  metadata {
    name      = var.caravan_app_name
    namespace = var.namespace_name
    labels = {
      app = var.caravan_app_name
    }
  }

  spec {
    replicas = var.caravan_pods

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
              cpu    = var.caravan_cpu
              memory = var.caravan_memory
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "caravan-load" {
  count = var.enable_caravan ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load]

  metadata {
    name      = var.caravan_app_name
    namespace = var.namespace_name
    annotations = {
      "cloud.google.com/neg": "{\"ingress\": true}"
    }
  }

  spec {
    selector = {
      app = var.caravan_app_name
    }
    port {
      name        = "http"
      port        = 8081
      target_port = 8081
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "caravan-load" {
  count = var.enable_caravan ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load, kubernetes_secret_v1.app-deploy-load-secret]
  
  metadata {
    name = var.caravan_app_name
    namespace = var.namespace_name
    annotations = {
      "kubernetes.io/ingress.class": "gce"
      "kubernetes.io/ingress.allow-http": "true"
      "kubernetes.io/ingress.global-static-ip-name": "caravan-load-testing-static-ip"
      "networking.gke.io/v1beta1.FrontendConfig": kubernetes_manifest.caravan-load-frontend-config.object.metadata.name
    }
  }

  spec {
    rule {
      host = "caravan-loadtest.likeminds.community"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = var.caravan_app_name
              port {
                number = 8081
              }
            }
          }
        }
      }
    }

    tls {
      secret_name = "app-deploy-load-secret"
    }
  }
}

resource "kubernetes_manifest" "caravan-load-frontend-config" {

  depends_on = [kubernetes_namespace.app-deploy-load]

  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"
    metadata = {
      name      = "caravan-load-frontend-config"
      namespace = var.namespace_name
    }
    spec = {
      redirectToHttps = {
        enabled = true
      }
    }
  }
}
