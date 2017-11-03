#!/bin/bash
set -x
OSD_PUBLIC_NETWORK=172.17.0.1/16
OSD_CLUSTER_NETWORK=172.17.0.1/16
WORK_DIR=/opt/openstack-helm

: ${CEPH_RGW_KEYSTONE_ENABLED:="true"}
helm install --namespace=openstack ${WORK_DIR}/ceph --name=radosgw-openstack \
   --set endpoints.identity.namespace=openstack \
   --set endpoints.object_store.namespace=ceph \
   --set endpoints.ceph_mon.namespace=ceph \
   --set ceph.rgw_keystone_auth=${CEPH_RGW_KEYSTONE_ENABLED} \
   --set network.public=${OSD_PUBLIC_NETWORK} \
   --set network.cluster=${OSD_CLUSTER_NETWORK} \
   --set deployment.storage_secrets=false \
   --set deployment.ceph=false \
   --set deployment.rbd_provisioner=false \
   --set deployment.client_secrets=false \
   --set deployment.rgw_keystone_user_and_endpoints=true \
   --values=${WORK_DIR}/tools/overrides/mvp/ceph.yaml

sleep 10
kubectl get -n openstack pods --show-all

export OS_CLOUD=openstack_helm
openstack service list
openstack container create 'mygreatcontainer'
openstack object create --name 'superimportantfile.jpg' 'mygreatcontainer' /home/ubuntu/important-file.jpg
