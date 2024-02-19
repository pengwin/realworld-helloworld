variable "namespace" {
  type        = string
  description = "Namespace for the hello world service"
}

variable "charts_path" {
  type        = string
  description = "Path to local charts"
}

variable "jaeger" {
  type = object({
    namespace         = string,
    collector_service = string
    collector_port    = number
  })
  description = "Jaeger configuration"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the hello world service"
}
