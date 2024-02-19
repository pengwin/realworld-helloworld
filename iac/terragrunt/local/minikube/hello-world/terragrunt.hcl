include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/hello-world.hcl"
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

inputs = {
  domain_name = "hello.local"
}