#!/bin/bash
set -x
WORK_DIR=/opt/openstack-helm

helm install --namespace=openstack ${WORK_DIR}/nova --name=nova\
    --set conf.nova.libvirt.virt_type=qemu
helm install --namespace=openstack ${WORK_DIR}/neutron --name=neutron \
    --values=${WORK_DIR}/tools/overrides/mvp/neutron-ovs.yaml

sleep 10
kubectl get -n openstack pods

export OS_CLOUD=openstack_helm
openstack service list
openstack hypervisor list
openstack network agent list


# Assign IP address to br-ex
OSH_BR_EX_ADDR="172.24.4.1/24"
OSH_EXT_SUBNET="172.24.4.0/24"
sudo ip addr add ${OSH_BR_EX_ADDR} dev br-ex
sudo ip link set br-ex up

# Setup masquerading on default route dev to public subnet
DEFAULT_ROUTE_DEV="ens3"
sudo iptables -t nat -A POSTROUTING -o ${DEFAULT_ROUTE_DEV} -s ${OSH_EXT_SUBNET} -j MASQUERADE
