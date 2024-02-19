module "cert" {
  source = "./modules/cert"

  cert_common_name           = var.cert_common_name
  cert_dns_names             = var.cert_dns_names
  cert_organization          = var.cert_organization
  cert_validity_period_hours = 24 * 365
}

resource "kubernetes_secret" "tls-cert" {
  metadata {
    name      = var.tls_secret_name
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }

  data = {
    "tls.crt" = module.cert.certificate
    "tls.key" = module.cert.private_key
  }

  type = "kubernetes.io/tls"
}
