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
vim /etc/fstab --> comment out the swap or swap will start again upon restart
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
token: cb9554.766507458d900744
192.168.2.241:6443
HASH: sha256:61176f7438054a684cddd491d520ecb07c9cd8879314dd85066b4bf8bb6e30da

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
### install Weave Net

```
$ kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
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

Create service account for TILLER
```
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller --clusterole cluster-admin --serviceaccount=kube-system:tiller
kubectl -n kube-system patch deploy/tiller-deploy -p '{"spec": {"template": {"spec": {"serviceAccountName": "tiller"}}}}'

```
Install rook controllers and operators


```
helm repo add rook-master https://charts.rook.io/master
helm search rook
helm install rook-master/rook --version <LATEST VERSION> --namespace rook -n rook
kubectl --namespace rook get pods -l app=rook-operator
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

Setup memcache and flux RBAC
```
kubectl apply -f setup/flux/memcache-dep.yaml,setup/flux/memcache-svc.yaml
kubectl apply -f setup/flux/flux-account.yaml
```

Install ssh key for flux
```
kubectl create secret generic flux-git-deploy --from-file=identity=$HOME/.ssh/id_rsa -n kube-system
```

Install flux and helm operator
```
kubectl apply -f setup/flux/flux-deployment.yaml
kubectl apply -f setup/flux/helm-operator-deployment.yaml
```

## RESSETING STUFF
```
kubeadm reset
systemctl stop kubelet
systemctl stop docker
rm -rf /var/lib/cni/
rm -rf /var/lib/kubelet/*
rm -rf /etc/cni/
ifconfig cni0 down
ifconfig flannel.1 down
ifconfig docker0 down
ip link delete cni0
ip link delete flannel.1
```
Worst case just reinstall ubuntu LOL

## IP Address STUFF

```
vim /etc/network/interfaces

change inet auto to inet static
address 192.168.2.241 & 242
netmask 255.255.255.0
gateway 192.168.2.254
dns-nameservers 8.8.8.8 8.8.4.4

sudo /etc/init.d/networking restart
```
