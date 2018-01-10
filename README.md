# k8s-nuc

## Setup Helm

```
kubectl create -f ./helm/tiller-rbac.yaml && \
  helm init --service-account tiller
```

## Configuring W/Helm

### Installing Configuration
```
helm dependency build ./core
helm install -n core --namespace core ./core
```

### Upgrading Deployment
```
helm dependency update ./core
helm upgrade core ./core --namespace core
```