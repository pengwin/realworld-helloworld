locals {
  port = 5080
}

resource "helm_release" "hello-proto-world-service" {
  name  = var.name
  chart = "${var.charts_path}/microservice"

  namespace = var.namespace

  atomic = true

  timeout = 600

  values = [yamlencode({
    replicaCount = 3
    image = {
      repository = var.image
      tag        = var.image_tag
    }

    nameOverride     = var.name
    fullnameOverride = var.name

    securityContext = {
      runAsNonRoot = false
    }

    pod = {
      ports = {
        httpPort = local.port
      }
    }

    env = [{
      name  = "ASPNETCORE_URLS"
      value = "http://+:${local.port}"
      }, {
      name  = "OTEL_EXPORTER_OTLP_ENDPOINT"
      value = var.jaeger_collector_endpoint
      }, {
      name  = "OTEL_EXPORTER_OTLP_PROTOCOL"
      value = "grpc"
    }]
  })]
}
