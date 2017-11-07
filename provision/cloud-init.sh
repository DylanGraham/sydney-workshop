#!/bin/bash
set -ex

echo "ubuntu:openstackhelm" | sudo -H chpasswd
sudo -H sed -i 's|PasswordAuthentication no|PasswordAuthentication yes|g' /etc/ssh/sshd_config
sudo -H systemctl restart sshd

sudo -H apt-get update
sudo -H apt-get install -y git jq nmap

sudo -H chown -R ubuntu: /opt

sudo -H su -c 'git clone https://git.openstack.org/openstack/openstack-helm-infra /opt/openstack-helm-infra' ubuntu
sudo -H su -c '(cd /opt/openstack-helm-infra; git reset --hard 75b656dc58d97dfbf02184c31fb4551ce507c773)' ubuntu
sudo -H su -c '/opt/openstack-helm-infra/tools/gate/devel/start.sh' ubuntu

sudo -H su -c 'git clone https://git.openstack.org/openstack/openstack-helm /opt/openstack-helm' ubuntu
sudo -H su -c '(cd /opt/openstack-helm; git reset --hard 4399e39a9cd7b7b878aaf137cefd39a0dff81a06)' ubuntu
sudo -H su -c '(cd /opt/openstack-helm; sudo -H make pull-all-images)' ubuntu
sudo -H su -c '(cd /opt/openstack-helm; kubectl replace -f ./tools/kubeadm-aio/assets/opt/rbac/dev.yaml)' ubuntu
sudo -H su -c '(cd /opt/openstack-helm; make)' ubuntu
sudo -H pip install python-openstackclient python-heatclient

sudo -H su -c 'git clone https://github.com/portdirect/sydney-workshop.git /opt/sydney-workshop' ubuntu
sudo -H su -c 'cp -rav /opt/sydney-workshop/*.sh ${HOME}/' ubuntu

sudo -H mkdir -p /etc/openstack
cat << EOF | sudo -H tee -a /etc/openstack/clouds.yaml
clouds:
  openstack_helm:
    region_name: RegionOne
    identity_api_version: 3
    auth:
      username: 'admin'
      password: 'password'
      project_name: 'admin'
      project_domain_name: 'default'
      user_domain_name: 'default'
      auth_url: 'http://keystone.openstack.svc.cluster.local/v3'
EOF
sudo -H chown -R ubuntu: /etc/openstack

sudo -H su -c 'curl -L -o /home/ubuntu/important-file.jpg https://imgflip.com/s/meme/Cute-Cat.jpg' ubuntu
