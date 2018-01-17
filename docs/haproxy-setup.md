# Raspberry Pi / HAProxy

Install HAProxy onto the Raspberry Pi node

```
apt-get install -y haproxy
```

After installing, add this to the end of `/etc/haproxy/haproxy.cfg`

```
frontend raspberrypi 
    bind *:80
    mode http
    default_backend nucs

backend nucs
    mode http
    balance roundrobin
    server k8s-nuc1 k8s-nuc1.lan:32080
    server k8s-nuc2 k8s-nuc2.lan:32080
    server k8s-nuc3 k8s-nuc3.lan:32080
    server k8s-nuc4 k8s-nuc4.lan:32080

listen stats *:1936  
    stats enable
    stats uri /
```

Once this has been configured run

```
systemctl restart haproxy
```