#!/bin/bash
sudo yum update -y
sudo yum install nginx -y
pushd $HOME
curl -LO https://github.com/traefik/traefik/releases/download/v2.10.4/traefik_v2.10.4_linux_amd64.tar.gz
tar -zxvf traefik_v2.10.4_linux_amd64.tar.gz
chmod +x traefik
sudo mv traefik /bin/
curl -L -o opa https://openpolicyagent.org/downloads/v0.55.0/opa_linux_amd64_static
chmod +x opa
sudo mv opa /bin/
popd