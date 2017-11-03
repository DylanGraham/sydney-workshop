#!/bin/bash
set -x
WORK_DIR=/opt/openstack-helm

helm install --namespace=openstack ${WORK_DIR}/horizon --name=horizon \
    --set network.node_port=31000 \
    --set network.enable_node_port=true

sleep 10
kubectl get -n openstack pods
