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
cd ansible && ansible-playbook --diff bare-metal.yaml
```

---

### Base Image

Ensure that QEMU is installed so we can build on Mac

```
brew install qemu --with-sdl2
```

Then build the images for Virtualbox and QEMU!

```
cd packer && packer build -only=qemu base.json
```

When completed, upload the QEMU images to the baremetal boxes

```
cd ansible && ansible-playbook --diff qemu-upload.yaml
```