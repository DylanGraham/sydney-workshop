#!/bin/bash
set -x

#NOTE: Deploy command
helm install /opt/openstack-helm/cinder \
  --namespace=openstack \
  --name=cinder

#NOTE: Wait for deploy
export KUBECONFIG=${HOME}/.kube/config
/opt/openstack-helm/tools/kubeadm-aio/assets/usr/bin/wait-for-kube-pods openstack

#NOTE: Validate Deployment info
export OS_CLOUD=openstack_helm
openstack service list
sleep 15
openstack volume type list
