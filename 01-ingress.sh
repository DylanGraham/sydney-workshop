#!/bin/bash
set -x

#NOTE: Deploy command
helm install /opt/openstack-helm/ingress \
  --namespace=openstack \
  --name=ingress

#NOTE: Wait for deploy
export KUBECONFIG=${HOME}/.kube/config
/opt/openstack-helm/tools/kubeadm-aio/assets/usr/bin/wait-for-kube-pods openstack

#NOTE: Display info
helm status ingress
