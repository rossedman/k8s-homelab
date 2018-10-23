# Bare Metal Hosts Setup

Install python on all nodes so we can run Ansible! This could be done with preseed but this is easy.

```
sudo apt install -y python-minimal
```

Set sudo to be passwordless for main user

```
sudo visudo

## make this passwordless
rossedman ALL=(ALL) NOPASSWD: ALL
```

Once this has been completed we run our Ansible against our bare metal hosts

```
cd ansible
ansible-playbook --diff metal.yaml
ansible-playbook --diff nfs.yaml
```

Here are some helpful commands for debugging and finding information

```
# view all facts about host
ansible -m setup octo1.lan -i hosts
```

---

### Base Image

There is a base image for running VMs that is similar to the metal servers themselves. This is built to work locally as well as run denser workloads on the metal servers for easy practice.

Ensure that QEMU is installed so we can build on Mac

```
brew install qemu --with-sdl2
```

Then build the images for Virtualbox and QEMU!

```
cd packer && packer build -only=qemu base.json
```