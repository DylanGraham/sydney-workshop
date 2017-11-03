#!/bin/bash
set -x
WORK_DIR=/opt/openstack-helm

# NOTE(portdirect), this could be: radosgw, rbd, swift or pvc
GLANCE_BACKEND="radosgw"
helm install --namespace=openstack ${WORK_DIR}/glance --name=glance \
  --set storage=${GLANCE_BACKEND}

sleep 10
kubectl get -n openstack pods

export OS_CLOUD=openstack_helm
openstack service list
openstack image list
openstack image show 'Cirros 0.3.5 64-bit'
