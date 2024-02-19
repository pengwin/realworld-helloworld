locals {
  namespace   = var.namespace
  domain_name = var.domain_name

  tls_secret_name = "hello-tls"

  hello_world_name          = "hello-world"
  hello_proto_world_name    = "hello-proto-world"
  observability_namespace   = var.jaeger.namespace         #"observability"
  jaeger_collector_service  = var.jaeger.collector_service #"jaeger-collector"
  jaeger_collector_port     = var.jaeger.collector_port    #4317
  jaeger_collector_endpoint = "http://${local.jaeger_collector_service}.${local.observability_namespace}.svc.cluster.local:${local.jaeger_collector_port}"
}

resource "kubernetes_namespace" "hello-namespace" {
  metadata {
    name = local.namespace
  }
}

module "tls_secret" {
  source = "./modules/tls_secret"

  namespace         = local.namespace
  cert_common_name  = local.domain_name
  cert_dns_names    = [local.domain_name]
  cert_organization = "Hello-world Ltd."

  tls_secret_name = local.tls_secret_name

  depends_on = [kubernetes_namespace.hello-namespace]
}

module "hello_world" {
  source = "./modules/hello-world-service"

  namespace                 = local.namespace
  charts_path               = var.charts_path
  image                     = "real-hello-world"
  image_tag                 = "0.0.3"
  name                      = local.hello_world_name
  jaeger_collector_endpoint = local.jaeger_collector_endpoint
}

module "hello_proto_world" {
  source = "./modules/hello-proto-world-service"

  namespace                 = local.namespace
  charts_path               = var.charts_path
  image                     = "real-hello-proto-world"
  image_tag                 = "0.0.3"
  name                      = local.hello_proto_world_name
  jaeger_collector_endpoint = local.jaeger_collector_endpoint
  tls_secret_name           = local.tls_secret_name
  hello_world_name          = local.hello_world_name
  ingress_domain            = local.domain_name

  depends_on = [module.tls_secret]
}
