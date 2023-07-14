
variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "cluster_name" {
    description = "gke cluster name"
}

variable "namespace_name" {
    description = "load application namespace name"
}

variable "kettle_app_name" {
    description = "kettle service app name"
}

variable "kettle_app_docker_image" {
    description = "kettle service docker image"
}