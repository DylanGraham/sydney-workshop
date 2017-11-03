#!/bin/bash
set -x
WORK_DIR=/opt/openstack-helm

helm install --namespace=openstack ${WORK_DIR}/mariadb --name=mariadb \
    --set pod.replicas.server=1

sleep 10
kubectl get -n openstack pods
kubectl get -n openstack pvc
