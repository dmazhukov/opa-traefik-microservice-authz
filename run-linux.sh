#!/bin/bash
sudo pkill nginx
sudo pkill app
sudo pkill traefik
sudo pkill opa

sudo cp -f nginx.conf /etc/nginx/nginx.conf
sudo mkdir -p /usr/share/nginx/html/api-1
sudo cp -f apps/api-1/index.html /usr/share/nginx/html/api-1/
sudo mkdir -p /usr/share/nginx/html/api-2
sudo cp -f apps/api-2/index.html /usr/share/nginx/html/api-2/
sudo cp -f apps/web/index.html /usr/share/nginx/html/index.html
sudo nginx

# sudo traefik-middlewares/auth-opa/app&

opa run --log-level=debug --server opa/groups.rego&

sudo mkdir -p /etc/traefik
sudo cp -f traefik/traefik.yml /etc/traefik/
sudo cp -f traefik/dynamic.yml /etc/traefik/
sudo traefik &
sudo traefik-middlewares/auth-opa/app &
