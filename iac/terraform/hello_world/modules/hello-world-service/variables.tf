variable "namespace" {
  type        = string
  description = "Namespace for the hello world service"
}

variable "charts_path" {
  type        = string
  description = "Path to local charts"
}

variable "name" {
  type        = string
  description = "Name of the hello world service"
}

variable "image" {
  type        = string
  description = "Docker image for the hello world service"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag for the hello world service"
}

variable "jaeger_collector_endpoint" {
  type        = string
  description = "Jaeger Collector endpoint"
  #default = "http://jaeger-collector.observability.svc.cluster.local:4317"
}