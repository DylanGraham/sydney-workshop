#!/bin/bash
set -x

#NOTE: Deploy command
helm install /opt/openstack-helm/memcached \
    --namespace=openstack \
    --name=memcached

#NOTE: Wait for deploy
export KUBECONFIG=${HOME}/.kube/config
/opt/openstack-helm/tools/kubeadm-aio/assets/usr/bin/wait-for-kube-pods openstack

#NOTE: Validate Deployment info
helm status memcached
