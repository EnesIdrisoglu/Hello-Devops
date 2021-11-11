terraform{
    required_providers{
        google={
            source="hashicorp/google"
            version="3.47.0"
        }
        kubernetes={
            source="hashicorp/kubernetes"
            version="2.6.1"
        }
    }
}

variable "project" {}
variable "region" { default="us-central1"}
variable "cluster_name" {}
variable "network" { default="default"}
variable "subnetwork" {default=""}
variable "ip_range_pods" {default=""}
variable "ip_range_services" {default=""}

module "gke" {
    source  = "terraform-google-modules/kubernetes-engine/google"
    version="17.1.0"
    project_id = var.project
    name = var.cluster_name
    region = var.region
    zones  = ["us-central1-a"]
    network = var.network
    subnetwork = var.subnetwork
    ip_range_pods = var.ip_range_pods
    ip_range_services = var.ip_range_services
    kubernetes_version = "1.20.10-gke.1600"
    create_service_account = false
    remove_default_node_pool = true

    node_pools = [{
        name="microservices"
        machine_type = "n1-standard-1"
        min_count = 1
        max_count = 5
        initial_node_count = 2
    }]
}

data "google_client_config" "current" {}

provider "kubernetes"{
    host = "https://${module.gke.endpoint}"
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
    token = data.google_client_config.current.access_token
}


resource "kubernetes_deployment" "example" {
  metadata {
    name = "terraform-example"
    labels = {
      test = "PythonApp"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "PythonApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "PythonApp"
        }
      }

      spec {
        container {
          image = "enesid/python-docker"
          name  = "app"

          liveness_probe {
            http_get {
              path = "/"
              port = 3000

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}