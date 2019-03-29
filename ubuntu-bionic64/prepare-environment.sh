#!/usr/bin/env bash

# Add docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

# Add kubernetes repo
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# add-apt-repository \
#        "deb https://apt.kubernetes.io/ \
#        kubernetes-$(lsb_release -cs) \
#        main"


# Бионика на конец марта 2019 пока нет.
# Как появится разкомметнтировать блок выше и удалить этот.
add-apt-repository \
       "deb https://apt.kubernetes.io/ \
       kubernetes-xenial \
       main"

apt-get update && apt-get upgrade -y && apt-get install -y docker-ce kubelet kubeadm kubernetes-cni


systemctl enable docker && systemctl start docker
systemctl enable kubelet && systemctl start kubelet


# Прописываю хосты
# echo "192.168.0.10 master.k8s" >> /etc/hosts
# echo "192.168.0.11 node1.k8s" >> /etc/hosts
# echo "192.168.0.12 node2.k8s" >> /etc/hosts


# Активация net.bridge.bridge-nf-call-iptables в ядре
sysctl -w net.bridge.bridge-nf-call-iptables=1
echo "net.bridge.bridge-nf-call-iptables=1" > /etc/sysctl.d/k8s.conf


# Kubelet не будет работать, если включен swap
# Отключаю Своп
swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab