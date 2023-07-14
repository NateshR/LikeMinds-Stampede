resource "kubernetes_service" "kettle-load" {
  metadata {
    name = var.kettle_app_name
    namespace = var.namespace_name
  }
  spec {
    selector = {
      app = var.kettle_app_name
    }
    port {
      name = "http"
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}
