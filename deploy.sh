kubectl delete configmap dynamo-config -n dynamo-cloud
kubectl create configmap dynamo-config --from-file=configs -n dynamo-cloud

helm upgrade -i dynamo-llm ./chart \
  --set image=dekaregistry.cloudeka.id/cloudeka-system/dynamo-pipeline:0.0.2-nonroot