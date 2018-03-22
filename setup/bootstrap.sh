#!/bin/sh

RANCHER_TOKEN=$1
RANCHER_SECRET=$2
CLUSTER_NAME=$3

CLUSTER_ID=$(curl \
  -u "$RANCHER_TOKEN:$RANCHER_SECRET" \
  -X POST \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "{\"azureKubernetesServiceConfig\":null, \"googleKubernetesEngineConfig\":null, \"name\":\"$CLUSTER_NAME\", \"rancherKubernetesEngineConfig\":null}" \
  'https://rancher.infra.tc/v3/clusters' | jq -r .id)

KUBE_COMMAND=$(curl \
  -u "$RANCHER_TOKEN:$RANCHER_SECRET" \
  -X POST \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "{\"clusterId\":\"$CLUSTER_ID\", \"name\":\"\", \"namespaceId\":\"\"}" \
  'https://rancher.infra.tc/v3/clusterregistrationtokens' | jq -r .command)

$($KUBE_COMMAND)
