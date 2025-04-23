kubectl delete configmap dynamo-config
kubectl create configmap dynamo-config --from-file=/Users/raihanafiandi/Documents/Lintasarta/dynamo/deploy/Kubernetes/pipeline/configs -n dynamo-cloud

helm upgrade -i dynamo-llm ./chart \
    -f pipeline-values.yaml \
    --set image=dekaregistry.cloudeka.id/cloudeka-system/dynamo-pipeline:0.0.2-nonroot \
    --set dynamoIdentifier="graphs.agg_router:Frontend" \