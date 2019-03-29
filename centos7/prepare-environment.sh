#!/usr/bin/env bash

setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

systemctl disable firewalld && systemctl stop firewalld


cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y net-tools

yum install -y docker kubelet kubeadm kubectl kubernetes-cni


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




