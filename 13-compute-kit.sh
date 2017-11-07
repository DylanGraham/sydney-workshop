#!/bin/bash
set -x

#NOTE: Deploy command
helm install /opt/openstack-helm/nova \
    --namespace=openstack \
    --name=nova \
    --set conf.nova.libvirt.virt_type=qemu
helm install /opt/openstack-helm/neutron \
    --namespace=openstack \
    --name=neutron \
    --values=/opt/openstack-helm/tools/overrides/mvp/neutron-ovs.yaml

#NOTE: Wait for deploy
export KUBECONFIG=${HOME}/.kube/config
/opt/openstack-helm/tools/kubeadm-aio/assets/usr/bin/wait-for-kube-pods openstack

#NOTE: Validate Deployment info
export OS_CLOUD=openstack_helm
openstack service list
sleep 15
openstack hypervisor list
openstack network agent list
