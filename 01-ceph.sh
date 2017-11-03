#!/bin/bash
set -x
OSD_PUBLIC_NETWORK=172.17.0.1/16
OSD_CLUSTER_NETWORK=172.17.0.1/16
WORK_DIR=/opt/openstack-helm

: ${CEPH_RGW_KEYSTONE_ENABLED:="true"}
helm install --namespace=ceph ${WORK_DIR}/ceph --name=ceph \
    --set endpoints.identity.namespace=openstack \
    --set endpoints.object_store.namespace=ceph \
    --set endpoints.ceph_mon.namespace=ceph \
    --set ceph.rgw_keystone_auth=${CEPH_RGW_KEYSTONE_ENABLED} \
    --set network.public=${OSD_PUBLIC_NETWORK} \
    --set network.cluster=${OSD_CLUSTER_NETWORK} \
    --set deployment.storage_secrets=true \
    --set deployment.ceph=true \
    --set deployment.rbd_provisioner=true \
    --set deployment.client_secrets=false \
    --set deployment.rgw_keystone_user_and_endpoints=false \
    --set bootstrap.enabled=true \
    --values=${WORK_DIR}/tools/overrides/mvp/ceph.yaml

sleep 10
kubectl get -n ceph pods
sleep 60
kubectl get -n ceph pods

MON_POD=$(kubectl get pods \
  --namespace=ceph \
  --selector="application=ceph" \
  --selector="component=mon" \
  --no-headers | awk '{ print $1; exit }')
kubectl exec -n ceph ${MON_POD} -- ceph -s
