
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



