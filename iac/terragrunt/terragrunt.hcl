locals {
  charts_path = "${dirname(get_terragrunt_dir())}/helm-charts"
  hello_namespace = "hello"
  jaeger = {
    namespace         = "observability"
    collector_service = "jaeger-collector"
    collector_port    = 4317
  }
}
