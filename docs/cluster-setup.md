## ON ALL NODES

### install docker

```
apt-get update && apt-get install -qy docker.io
```
  
### disable swap

```
cat /proc/swaps
swapoff /dev/dm-1
```