# k8s-homelab

This repo has all the instructions and configuration for my kubernetes homelab. This was built on 4 Intel NUCs and 1 Raspberry Pi, but could be built on any machines that can run the same software.

This cluster uses Weave Flux to pull configuration directly from this repo and then syncs it. 

This setup also uses Rook and the underlying SSDs to provision PVCs and block storage. The SSDs were 250GB and only 50GB was assigned to the OS, the rest was left empty so that Rook could provision storage volumes.

To setup this cluster follow these instructions:

- [Metal Setup](./docs/metal-setup.md)
- [Cluster Setup](./docs/cluster-setup.md)
- [HAProxy Setup](./docs/haproxy-setup.md)