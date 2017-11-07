#!/bin/bash
set -x

#NOTE: Deploy command
helm install /opt/openstack-helm/horizon \
    --namespace=openstack \
    --name=horizon \
    --set network.node_port=31000 \
    --set network.enable_node_port=true

#NOTE: Wait for deploy
export KUBECONFIG=${HOME}/.kube/config
/opt/openstack-helm/tools/kubeadm-aio/assets/usr/bin/wait-for-kube-pods openstack

#NOTE: Validate Deployment info
helm status horizon
