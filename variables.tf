variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "cluster_name" {
  description = "gke cluster name"
}

variable "tls_crt" {
  description = "tls certificate"
}

variable "tls_key" {
  description = "tls key"
}

variable "namespace_name" {
  description = "load application namespace name"
}

variable "enable_kettle" {
  description = "if to enable kettle service"
}

variable "kettle_app_name" {
  description = "kettle service app name"
}

variable "kettle_app_docker_image" {
  description = "kettle service docker image"
}

variable "kettle_cpu" {
  description = "kettle cpu"
}

variable "kettle_memory" {
  description = "kettle memory"
}

variable "enable_swarm" {
  description = "if to enable swarm service"
}

variable "swarm_app_name" {
  description = "swarm service app name"
}

variable "swarm_app_docker_image" {
  description = "swarm service docker image"
}

variable "swarm_cpu" {
  description = "swarm cpu"
}

variable "swarm_memory" {
  description = "swarm memory"
}

variable "enable_caravan" {
  description = "if to enable caravan service"
}

variable "caravan_app_name" {
  description = "caravan service app name"
}

variable "caravan_app_docker_image" {
  description = "caravan service docker image"
}

variable "caravan_cpu" {
  description = "caravan cpu"
}

variable "caravan_memory" {
  description = "caravan memory"
}

variable "caravan_celery_app_name" {
  description = "caravan celery app name"
}

variable "caravan_celery_app_docker_image" {
  description = "caravan celery app docker image"
}

variable "caravan_celery_cpu" {
  description = "caravan celery cpu"
}

variable "caravan_celery_memory" {
  description = "caravan celery memory"
}

variable "caravan_celery_broker_url" {
  description = "caravan celery broker url"
}

variable "caravan_rabbitmq_app_name" {
  description = "caravan rabbitmq app name"
}

variable "caravan_rabbitmq_app_docker_image" {
  description = "caravan rabbitmq app docker image"
}

variable "caravan_rabbitmq_username" {
  description = "caravan rabbitmq username"
}

variable "caravan_rabbitmq_password" {
  description = "caravan rabbitmq password"
}
