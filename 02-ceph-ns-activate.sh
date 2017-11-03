#!/bin/bash
set -x
OSD_PUBLIC_NETWORK=172.17.0.1/16
OSD_CLUSTER_NETWORK=172.17.0.1/16
WORK_DIR=/opt/openstack-helm

: ${CEPH_RGW_KEYSTONE_ENABLED:="true"}
helm install --namespace=openstack ${WORK_DIR}/ceph --name=ceph-openstack-config \
    --set endpoints.identity.namespace=openstack \
    --set endpoints.object_store.namespace=ceph \
    --set endpoints.ceph_mon.namespace=ceph \
    --set ceph.rgw_keystone_auth=${CEPH_RGW_KEYSTONE_ENABLED} \
    --set network.public=${OSD_PUBLIC_NETWORK} \
    --set network.cluster=${OSD_CLUSTER_NETWORK} \
    --set deployment.storage_secrets=false \
    --set deployment.ceph=false \
    --set deployment.rbd_provisioner=false \
    --set deployment.client_secrets=true \
    --set deployment.rgw_keystone_user_and_endpoints=false \
    --values=${WORK_DIR}/tools/overrides/mvp/ceph.yaml

sleep 10
kubectl get -n openstack pods --show-all
kubectl get -n openstack secrets
kubectl get -n openstack configmaps
