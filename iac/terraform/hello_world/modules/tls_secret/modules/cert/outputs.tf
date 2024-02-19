output "private_key" {
  value     = tls_private_key.cert_private_key.private_key_pem
  sensitive = true
}

output "certificate" {
  value = tls_self_signed_cert.cert.cert_pem
  sensitive = true
}
