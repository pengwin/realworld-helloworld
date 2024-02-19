helm install --debug --atomic --namespace hello -f ./iac/k8s/helm-values/hello-world/values.yaml hello-world ./iac/helm-charts/microservice
helm install --debug --atomic --namespace hello -f ./iac/k8s/helm-values/hello-proto-world/values.yaml hello-proto-world ./iac/helm-charts/microservice
