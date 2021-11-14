
# provider "helm" {
#   kubernetes {
#     host                   = "https://${data.google_container_cluster.cluster.endpoint}"
#     cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
#     exec {
#       api_version = "client.authentication.k8s.io/v1alpha1"
#       args        = ["eks", "get-token", "--cluster-name", data.google_container_cluster.cluster.name]
#       command     = "gke"
#     }
#   }
# }

# resource "helm_release" "mysql" {
#   name       = "mysql"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "mysql"

#   values = [
#     file("${path.module}/mysql-values.yaml")
#   ]
# }