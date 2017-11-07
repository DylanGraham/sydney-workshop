#!/bin/bash
set -x

#NOTE: Deploy command
GLANCE_BACKEND="radosgw" # NOTE(portdirect), this could be: radosgw, rbd, swift or pvc
helm install /opt/openstack-helm/glance \
  --namespace=openstack \
  --name=glance \
  --set storage=${GLANCE_BACKEND}

#NOTE: Wait for deploy
export KUBECONFIG=${HOME}/.kube/config
/opt/openstack-helm/tools/kubeadm-aio/assets/usr/bin/wait-for-kube-pods openstack

#NOTE: Validate Deployment info
helm status glance
export OS_CLOUD=openstack_helm
openstack service list
sleep 15
openstack image list
openstack image show 'Cirros 0.3.5 64-bit'
