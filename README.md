# k8s-homelab

This repo has all the instructions and configuration for my kubernetes homelab. This was built on 4 Intel NUCs and 1 Raspberry Pi, but could be built on any machines that can run the same software.

The initial setup of the nodes you will need a linux OS on the NUCs which may require
a bootable usb. If you would like to use a linux server image you can find the latest
[here](https://www.ubuntu.com/download/server).
And installation instructions can be found [here](https://tutorials.ubuntu.com/tutorial/tutorial-install-ubuntu-server#0)

This setup also uses Rook and the underlying SSDs to provision PVCs and block storage. The SSDs were 250GB and only 50GB was assigned to the OS, the rest was left empty so that Rook could provision storage volumes.

To setup this cluster follow these instructions:

- [Cluster Setup (Manual)](./docs/cluster-setup.md)
- [RKE Cluster Setup (automagic)](./docs/rke-setup.md)
- [RKE Download](https://github.com/rancher/rke/releases)
- [HAProxy Setup](./docs/haproxy-setup.md)
