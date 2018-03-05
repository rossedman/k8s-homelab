## ON ALL NODES

### install docker

```
apt-get update && apt-get install -qy docker.io
```

### install kube repo

```
apt-get update && apt-get install -y apt-transport-https \
  && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

apt-get update && apt-get install -y kubelet kubeadm kubernetes-cni
```
  
### disable swap

```
cat /proc/swaps
swapoff /dev/dm-1
```

---
  
## ON MASTER NODES

### init cluster

```
kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --apiserver-advertise-address=0.0.0.0 \
  --kubernetes-version stable-1.9 \
  --service-dns-domain cool.haus
```
  
### install kubeconfig

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### from laptop copy config down

```
scp redman@k8s-nuc4.lan:~/.kube/config .
```
  
### install flannel

```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/k8s-manifests/kube-flannel-rbac.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
```

---

## ON WORKER NODES

```
kubeadm join --token $TOKEN 192.168.86.80:6443 --discovery-token-ca-cert-hash $HASH
```

---

## SMOKE TEST

```
kubectl run guids --image=alexellis2/guid-service:latest --port 9000
kubectl get pods
```

---

## SETUP NODES & TILLER

```
kubectl taint nodes --all node-role.kubernetes.io/master
kubectl label node/k8s-nuc1 kubernetes.io/role=worker
kubectl label node/k8s-nuc2 kubernetes.io/role=worker
kubectl label node/k8s-nuc3 kubernetes.io/role=worker
```

```
kubectl create -f ./setup/tiller-rbac.yaml && \
  helm init --service-account tiller
```

---

## STORAGE

Install rook controllers and operators

```
helm repo add rook-master https://charts.rook.io/master
helm install rook-master/rook --version v0.7.0-10.g3bcee98 --namespace rook -n rook
```

Setup rook cluster, storage class and agent permissions

```
kubectl apply -f setup/storage/rook-cluster.yml
kubectl apply -f setup/storage/rook-storageclass.yml
kubectl apply -f setup/storage/rook-agent.yml
```

---

## FLUX

Setup flux and begin bootstrapping cluster configurations and deployments from git

```
kubectl apply -f setup/flux/flux-deployment.yml -n kube-system
kubectl apply -f setup/flux -n kube-system
```