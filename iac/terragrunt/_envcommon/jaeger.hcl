terraform {
  source = "${local.base_source_url}//jaeger"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  root_vars = read_terragrunt_config(find_in_parent_folders())
  env = local.environment_vars.locals.environment
  vars = merge(local.environment_vars.locals, local.root_vars.locals)
  base_source_url = "${dirname(find_in_parent_folders())}/../terraform"
}

inputs = {
  name = "jaeger"
  namespace  = local.vars.jaeger.namespace
}
