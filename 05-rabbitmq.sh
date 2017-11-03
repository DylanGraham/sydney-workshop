#!/bin/bash
set -x
WORK_DIR=/opt/openstack-helm


helm install --namespace=openstack ${WORK_DIR}/etcd --name=etcd-rabbitmq
helm install --namespace=openstack ${WORK_DIR}/rabbitmq --name=rabbitmq \
     --set pod.replicas.server=1

sleep 10
kubectl get -n openstack pods
