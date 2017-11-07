#!/bin/bash
set -x

#NOTE: Deploy command
helm install /opt/openstack-helm/etcd \
    --namespace=openstack \
    --name=etcd-rabbitmq
helm install /opt/openstack-helm/rabbitmq \
    --namespace=openstack \
    --name=rabbitmq \
    --set pod.replicas.server=1

#NOTE: Wait for deploy
export KUBECONFIG=${HOME}/.kube/config
/opt/openstack-helm/tools/kubeadm-aio/assets/usr/bin/wait-for-kube-pods openstack

#NOTE: Validate Deployment info
helm status etcd-rabbitmq
helm status rabbitmq
