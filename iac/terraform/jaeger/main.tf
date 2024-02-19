resource "helm_release" "jaeger" {
  name = var.name

  chart = "jaegertracing/jaeger"

  namespace = var.namespace
  create_namespace = true

  atomic = true

  timeout = 600

  values = [yamlencode({
    provisionDataStore : { cassandra : false },
    allInOne : { enabled : true },
    storage : { type : "none" },
    agent : { enabled : false },
    collector : { enabled : false },
    query : { enabled : false }
  })]
}
