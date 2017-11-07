#!/bin/bash
set -x

#NOTE: Deploy command
helm install /opt/openstack-helm/keystone \
    --namespace=openstack \
    --name=keystone

#NOTE: Wait for deploy
export KUBECONFIG=${HOME}/.kube/config
/opt/openstack-helm/tools/kubeadm-aio/assets/usr/bin/wait-for-kube-pods openstack

#NOTE: Validate Deployment info
helm status keystone
export OS_CLOUD=openstack_helm
openstack endpoint list
