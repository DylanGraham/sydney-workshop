#!/bin/bash
set -x
WORK_DIR=/opt/openstack-helm

helm install --namespace=openstack ${WORK_DIR}/ingress --name=ingress

sleep 10
kubectl get -n openstack pods
