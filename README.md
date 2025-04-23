# Deploy Dynamo pipeline using Helm on DekaGPU's Kubernetes

### Prerequisites

*Install Nats*
```bash
# Navigate to dependencies directory
cd dependencies

# Add and update NATS Helm repository
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm repo update

# Install NATS with custom values
helm install dynamo-platform-nats nats/nats \
    --values nats-values.yaml
```

*Install etcd*
```bash
# Install etcd using Bitnami chart
helm install dynamo-platform-etcd \
    oci://registry-1.docker.io/bitnamicharts/etcd \
    --values etcd-values.yaml
```

### Setting up Image Pull Secrets

Before deploying, you need to ensure your Kubernetes namespace has the appropriate image pull secret configured. The Helm chart uses `docker-imagepullsecret` by default.

You can create this secret in your namespace using:
```bash
kubectl create secret docker-registry docker-imagepullsecret \
    --docker-server=<registry-server> \
    --docker-username=<username> \
    --docker-password=<password> \
    -n <namespace>
```

Alternatively, you can modify the `imagePullSecrets` section in `deploy/Kubernetes/pipeline/chart/values.yaml` to match your registry credentials.

### Install the Helm chart

```bash
bash deploy.sh
```

### Test the deployment

```bash
# Forward the service port to localhost
kubectl -n <k8s_namespace> port-forward svc/hello-world-frontend 3000:80

# In another terminal window, test the API endpoint
curl -X 'POST' 'http://localhost:3000/v1/completions' \
    -H 'accept: text/event-stream' \
    -H 'Content-Type: application/json' \
    -d '{
    "model": "deepseek-ai/DeepSeek-R1-Distill-Llama-8B",
    "messages": [
    {
        "role": "user",
        "content": "In the heart of Eldoria, an ancient land of boundless magic and mysterious creatures, lies the long-forgotten city of Aeloria. Once a beacon of knowledge and power, Aeloria was buried beneath the shifting sands of time, lost to the world for centuries. You are an intrepid explorer, known for your unparalleled curiosity and courage, who has stumbled upon an ancient map hinting at ests that Aeloria holds a secret so profound that it has the potential to reshape the very fabric of reality. Your journey will take you through treacherous deserts, enchanted forests, and across perilous mountain ranges. Your Task: Character Background: Develop a detailed background for your character. Describe their motivations for seeking out Aeloria, their skills and weaknesses, and any personal connections to the ancient city or its legends. Are they driven by a quest for knowledge, a search for lost familt clue is hidden."
    }
    ],
    "stream":false,
    "max_tokens": 10
  }'
```