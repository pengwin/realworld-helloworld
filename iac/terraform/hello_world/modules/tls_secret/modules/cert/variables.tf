variable "cert_common_name" {
  type        = string
  description = "Common name for the certificate"
}

variable "cert_dns_names" {
  type        = list(string)
  description = "DNS names for the certificate"
}

variable "cert_organization" {
  type        = string
  description = "Organization for the certificate"
}

variable "cert_validity_period_hours" {
  type        = number
  description = "Validity period for the certificate in hours"
}
