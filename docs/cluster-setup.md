# Cluster Setup

## Kubernetes Configuration

RKE is needed, but once installed run this command to create a cluster

```
rke up --config cluster.yml
```

## Core Cluster Components

This will set up the full monitoring stack with PVCs created from NFS.

```
kubectl apply -f config/monitoring/influxdb
kubectl apply -f config/monitoring/telegraf
kubectl apply -f config/monitoring/grafana
```