variable "cert_common_name" {
  type        = string
  description = "Common name for the certificate"
}

variable "cert_organization" {
  type        = string
  description = "Organization for the certificate"
}

variable "cert_dns_names" {
  type        = list(string)
  description = "DNS names for the certificate"
}

variable "namespace" {
  type        = string
  description = "Namespace for the tls secret"
}

variable "tls_secret_name" {
  type        = string
  description = "Name of the tls secret"
}




