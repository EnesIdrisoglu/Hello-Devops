provider "google" {
  credentials = file("hello-devops-331819-099935112699.json")
  region  = var.region
}

data "google_client_config" "current" {}


provider "kubernetes"{
    host = "https://${module.gke.endpoint}"
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
    token = data.google_client_config.current.access_token

}

resource "kubernetes_namespace" "hello-devops" {
  metadata {
    name = "hello-devops"
  }
}

resource "kubernetes_deployment" "hello-devops" {
  metadata {
    name      = var.application_name
    namespace = kubernetes_namespace.hello-devops.id
    labels = {
      app = var.application_name
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = var.application_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.application_name
        }
      }
      spec {
        container {
          image = "enesid/python-docker"
          name  = var.application_name
        }
      }
    }
  }
}

resource "kubernetes_service" "hello-devops" {
  metadata {
    name      = var.application_name
    namespace = kubernetes_namespace.hello-devops.id
  }
  spec {
    selector = {
      app = kubernetes_deployment.hello-devops.metadata[0].labels.app
    }
    port {
      port        = 3000
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}