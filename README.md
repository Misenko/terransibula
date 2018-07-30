# Docker image containing Terraform + Ansible provisioner + OpenNebula provider
## Run
```bash
docker run -it --rm -v $(pwd):/app metacentrumuniverse/terransibula <terraform command>
```
When using Ansible provisioner you would have to provide access to either passwordless SSH keys or unlocked SSH keyring to provide access to provisioned machine. For example:
```bash
docker run -it --rm -v $(pwd):/app -v ${SSH_AUTH_SOCK}:/root/ssh -e "SSH_AUTH_SOCK=/root/ssh" metacentrumuniverse/terransibula <terraform command>
```
