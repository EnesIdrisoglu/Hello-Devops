variable "project" { default="hello-devops-331819"}
variable "region" { default="us-central1"}
variable "cluster_name" { default="devops"}
variable "network" { default="default"}
variable "subnetwork" {default=""}
variable "ip_range_pods" {default=""}
variable "ip_range_services" {default=""}
variable "application_name" {
  type    = string
  default = "hello-devops"
}