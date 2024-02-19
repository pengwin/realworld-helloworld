resource "tls_private_key" "cert_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "cert" {
  private_key_pem       = tls_private_key.cert_private_key.private_key_pem
  validity_period_hours = var.cert_validity_period_hours
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
  dns_names          = var.cert_dns_names
  is_ca_certificate  = true
  set_subject_key_id = true

  subject {
    common_name = var.cert_common_name
  }
}


