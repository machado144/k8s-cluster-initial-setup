# Cluster Setup Guide

This guide will walk you through the setup of a Kubernetes cluster, including the installation of necessary tools and the deployment of applications using GitOps with ArgoCD.

## Tools Required

To begin, ensure you have the following tools installed:

- **Envgsub**: [Download Script](https://gist.github.com/machado144/6122f7ccc108c716bdf4df3dba676ab4)
- **Opentofu**
- **gcloud**
- **gsutil**
- **kubectl**

By following this guide, you will have the `envgsub` command fully working. The other tools should also be installed and ready to use.

## Setting Up Envgsub

To install `envgsub`, follow these steps:

1. **Download the Script**

   ```bash
   curl -o envgsub.sh https://gist.githubusercontent.com/machado144/6122f7ccc108c716bdf4df3dba676ab4/raw/e37de91a0e5c42221c49941a5b02dcc212c2ed2b/envgsub.sh
   ```

2. **Grant Execution Permission**

   ```bash
   chmod +x envgsub.sh
   ```

3. **Move the Script to `/usr/local/bin`**

   ```bash
   sudo mv envgsub.sh /usr/local/bin/envgsub
   ```

### Running Envgsub

To replace environment variables in your `.tpl` files, run:

```bash
envgsub
```

If you want to replace and then delete the `.tpl` files, run:

```bash
envgsub --delete-tpl
```

This command will search and replace all environment variables in the `.tpl` files in the current directory, prompting you for values.

## Configuring the Infrastructure

### Step 1: Create the State Bucket

Navigate to your Infrastructure as Code (IaC) directory and create a bucket to store the Opentofu state:

```bash
gsutil mb gs://[bucket-name-you-provided-on-envgsub-command]
```

### Step 2: Initialize Opentofu

Initialize and set up the Opentofu workspace:

```bash
tofu init
tofu workspace new dev
tofu workspace select dev
tofu plan -var-file=environments/dev.tfvars
```

Now that our application is deployed, we can connect to the cluster and verify that it's working.

```bash
gcloud container clusters get-credentials $CLUSTER_NAME --zone us-central1-a --project $PROJECT_ID
kubectl get pods
```

### Step 3: Deploying Applications with ArgoCD

ArgoCD is a tool to manage your applications using GitOps. To set up ArgoCD, follow these steps:

1. **Connect to the Cluster**
   
   Add your cluster's context to the kubeconfig file.

2. **Install ArgoCD**

   ```bash
   export ARGOCD_VERSION=v2.12.1
   kubectl create namespace argocd
   kubectl apply -n argocd \
     -f "https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"
   ```

### Accessing the ArgoCD UI

To access the ArgoCD UI:

1. **Install the ArgoCD CLI**: [CLI Installation Guide](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
2. **Port Forward to Access the UI**

   ```bash
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```

3. **Retrieve the Initial Password**

   ```bash
   kubectl get secrets -n argocd argocd-initial-admin-secret -o json | jq -r .data.password | base64 -d
   ```

4. **Login to ArgoCD Using the CLI**

   ```bash
   argocd login localhost:8080
   ```

5. **Change the Initial Password**

   ```bash
   argocd account update-password
   ```

### Step 4: Deploying Nginx Ingress Controller

Our first application deployment will be the Nginx Ingress Controller to expose our applications using Ingress.

```bash
kubectl create namespace ingress-nginx
argocd app create nginx-ingress \
  --repo https://kubernetes.github.io/ingress-nginx \
  --helm-chart ingress-nginx \
  --revision 4.6.0 \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace ingress-nginx \
  --sync-policy automated \
  --helm-set controller.service.type=LoadBalancer

argocd app sync nginx-ingress
```

### Step 5: Retrieve the External IP for Ingress

After deploying the Nginx Ingress Controller, retrieve its external IP. This IP will be used with `nip.io` to create a dynamic IP for your applications.

```bash
export INGRESS_IP=$(kubectl get svc -n ingress-nginx \
  nginx-ingress-ingress-nginx-controller -o json \
  | jq -r '.status.loadBalancer.ingress[0].ip')
```

### Step 6: Deploy Your Application (Podinfo)

With ArgoCD and Nginx Ingress set up, you can now deploy your applications. Here's how to deploy `podinfo`:

```bash
kubectl create namespace podinfo
argocd app create podinfo \
  --repo https://github.com/stefanprodan/podinfo.git \
  --path charts/podinfo \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace podinfo \
  --helm-set service.type=ClusterIP \
  --helm-set ingress.enabled=true \
  --helm-set "ingress.hosts[0].host=podinfo.$INGRESS_IP.nip.io" \
  --helm-set "ingress.hosts[0].paths[0].path=/" \
  --helm-set "ingress.hosts[0].paths[0].pathType=Prefix" \
  --helm-set ingress.className=nginx \
  --sync-policy automated
```

### Access Your Application

Once deployed, you can access your application at:

`http://podinfo.$INGRESS_IP.nip.io/`

Now you have a fully functioning Kubernetes cluster with automated deployments managed by ArgoCD!
