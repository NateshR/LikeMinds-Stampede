resource "kubernetes_deployment" "kettle-load" {
  count = var.enable_kettle ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load]

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

  depends_on = [kubernetes_namespace.app-deploy-load]

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

  depends_on = [kubernetes_namespace.app-deploy-load, kubernetes_secret_v1.app-deploy-load-secret]
  
  metadata {
    name = var.kettle_app_name
    namespace = var.namespace_name
    annotations = {
      "kubernetes.io/ingress.class": "gce"
      "kubernetes.io/ingress.allow-http": "true"
      "kubernetes.io/ingress.global-static-ip-name": "kettle-load-testing-static-ip"
      "networking.gke.io/v1beta1.FrontendConfig": kubernetes_manifest.kettle-load-frontend-config.object.metadata.name
    }
  }

  spec {
    rule {
      host = "kettle-loadtest.likeminds.community"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = var.kettle_app_name
              port {
                number = 8080
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

resource "kubernetes_manifest" "kettle-load-frontend-config" {

  depends_on = [kubernetes_namespace.app-deploy-load]

  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"
    metadata = {
      name      = "kettle-load-frontend-config"
      namespace = var.namespace_name
    }
    spec = {
      redirectToHttps = {
        enabled = true
      }
    }
  }
}
