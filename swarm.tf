resource "kubernetes_deployment" "swarm-load" {
  count = var.enable_swarm ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load]

  metadata {
    name      = var.swarm_app_name
    namespace = var.namespace_name
    labels = {
      app = var.swarm_app_name
    }
  }

  spec {
    replicas = var.swarm_pods

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
              cpu    = var.swarm_cpu
              memory = var.swarm_memory
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "swarm-load" {
  count = var.enable_swarm ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load]

  metadata {
    name      = var.swarm_app_name
    namespace = var.namespace_name
    annotations = {
      "cloud.google.com/neg": "{\"ingress\": true}"
    }
  }

  spec {
    selector = {
      app = var.swarm_app_name
    }
    port {
      name        = "http"
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "swarm-load" {
  count = var.enable_swarm ? 1 : 0

  depends_on = [kubernetes_namespace.app-deploy-load, kubernetes_secret_v1.app-deploy-load-secret]
  
  metadata {
    name = var.swarm_app_name
    namespace = var.namespace_name
    annotations = {
      "kubernetes.io/ingress.class": "gce"
      "kubernetes.io/ingress.allow-http": "true"
      "kubernetes.io/ingress.global-static-ip-name": "swarm-load-testing-static-ip"
      "networking.gke.io/v1beta1.FrontendConfig": kubernetes_manifest.swarm-load-frontend-config.object.metadata.name
    }
  }

  spec {
    rule {
      host = "swarm-loadtest.likeminds.community"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = var.swarm_app_name
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

resource "kubernetes_manifest" "swarm-load-frontend-config" {

  depends_on = [kubernetes_namespace.app-deploy-load]

  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"
    metadata = {
      name      = "swarm-load-frontend-config"
      namespace = var.namespace_name
    }
    spec = {
      redirectToHttps = {
        enabled = true
      }
    }
  }
}
