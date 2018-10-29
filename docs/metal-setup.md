# Bare Metal Hosts Setup

## Host Bootstrapping

Install ssh keys from github

```
bash <(curl -L tiny.cc/rossedman-ssh)
```

Set sudo to be passwordless for main user

```
echo "rossedman ALL=(ALL) NOPASSWD: ALL" | sudo tee --append /etc/sudoers
sudo apt-get install -y python-minimal python-apt
```

## Host Configuration

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