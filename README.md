# k8s-nuc

## Setup Helm

```
kubectl create -f ./setup/tiller-rbac.yaml && \
  helm init --service-account tiller
```

## Configuring W/Helm

### Add Incubator

```
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com
```

### Installing Configuration
```
helm dependency build ./metrics
helm install -n metrics --namespace metrics ./metrics
```

### Upgrading Deployment
```
helm dependency update ./metrics
helm upgrade metrics ./metrics --namespace metrics
```