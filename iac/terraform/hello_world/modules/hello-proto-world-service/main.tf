locals {
  port      = 5080
  grpc_port = 5090
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
        grpcPort = local.grpc_port
      }
    }

    service = {
      type = "ClusterIP"
      port = 443
    }

    ingress = {
      enabled = true
      annotations = {
        "nginx.ingress.kubernetes.io/ssl-redirect"     = "true"
        "nginx.ingress.kubernetes.io/backend-protocol" = "GRPCS"
      }
      hosts = [{
        host = var.ingress_domain
        paths = [{
          path     = "/"
          pathType = "Prefix"
        }]
      }]
      tls = [{
        secretName = var.tls_secret_name
        hosts      = [var.ingress_domain]
      }]
    }

    volumes = [{
      name = "tls"
      secret = {
        secretName = var.tls_secret_name
      }
    }]

    volumeMounts = [{
      name      = "tls"
      mountPath = "/tls"
      readOnly  = true
    }]

    env = [{
      name  = "Kestrel__EndPoints__Http__Url"
      value = "http://+:${local.port}"
      }, {
      name  = "Kestrel__EndPoints__Https__Url"
      value = "https://+:${local.grpc_port}"
      }, {
      name  = "Kestrel__EndPoints__Https__Certificate__Path"
      value = "/tls/tls.crt"
      }, {
      name  = "Kestrel__EndPoints__Https__Certificate__KeyPath"
      value = "/tls/tls.key"
      }, /*{
      name  = "Kestrel__EndPoints__Https__Certificate__Password"
      value = var.tls_cert_password
      },*/ {
      name  = "HelloWorld__BaseUrl"
      value = "http://${var.hello_world_name}.${var.namespace}.svc.cluster.local:80"
      }, {
      name  = "OTEL_EXPORTER_OTLP_ENDPOINT"
      value = var.jaeger_collector_endpoint
      }, {
      name  = "OTEL_EXPORTER_OTLP_PROTOCOL"
      value = "grpc"
      }, {
      name  = "OTEL_DOTNET_EXPERIMENTAL_ASPNETCORE_ENABLE_GRPC_INSTRUMENTATION"
      value = "true"
    }]
  })]
}
