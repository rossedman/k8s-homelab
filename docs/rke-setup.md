## ON ALL NODES

### install docker
login as root which is `sudo su`
```
apt-get update && apt-get install -qy docker.io cowsay
```

### disable swap
```
cat /proc/swaps - (this lets you view if any swaps are enabled)
swapoff -a - (this turns off all the swaps in your session)
vim /etc/fstab - (you will need to comment/delete the swap)
```
### Enable SSH
```
sudo apt-get update && apt-get install -y openssh-server
```
On your laptop/desktop
```
ssh-keygen -t rsa - (if you dont have a ssh key already)

ssh-copy-id -i ~/.ssh/$key-name $user@host_ip_address - (exports ssh key to NUCs)

ssh $user@host_ip_address - (check to make sure you can ssh into NUCs)
```
## ON YOUR LAPTOP/DESKTOP

### Yeehaw RKE it up :cow:

```
rke up --config $yourconfig.yaml
```

### Register Cluster as Cattle :cow:
```
kubectl apply -f https://rancher.infra.tc/v3/import/mzws9t5j98vdh5q2pkdwfz9gwzb2cxmtcm8m7lgkcxtzfgkq6g4jbn.yaml
```

### TEAR IT DOWN :cow:
```
rke remove --config $yourconfig.yaml
```
---
## Install rook controllers and operators

```
helm repo add rook-master https://charts.rook.io/master
helm search rook
helm install rook-master/rook --version <LATEST VERSION> --namespace rook -n rook
kubectl --namespace rook get pods -l app=rook-operator
```

## Setup rook cluster, storage class and agent permissions

```
kubectl apply -f setup/storage/rook-cluster.yml
kubectl apply -f setup/storage/rook-storageclass.yml
kubectl apply -f setup/storage/rook-agent.yml
```
---

## RESETING STUFF
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
