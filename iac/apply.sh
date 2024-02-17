# hello-world

# apply deployment
kubectl apply -f ./iac/k8s/hello-world/deployment.yaml -n hello
# apply service
kubectl apply -f ./iac/k8s/hello-world/service.yaml -n hello

# hello-proto-world

# apply deployment
kubectl apply -f ./iac/k8s/hello-proto-world/deployment.yaml -n hello
# apply service
kubectl apply -f ./iac/k8s/hello-proto-world/service.yaml -n hello

# ingress
kubectl apply -f ./iac/k8s/ingress.yaml -n hello