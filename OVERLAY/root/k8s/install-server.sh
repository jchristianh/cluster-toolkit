#!/bin/bash

#setenforce 0
#sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux


#firewall-cmd --permanent --add-port=6443/tcp
#firewall-cmd --permanent --add-port=2379-2380/tcp
#firewall-cmd --permanent --add-port=10250/tcp
#firewall-cmd --permanent --add-port=10251/tcp
#firewall-cmd --permanent --add-port=10252/tcp
#firewall-cmd --permanent --add-port=10255/tcp
#firewall-cmd --reload
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables


cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg

EOF


yum install kubeadm docker qemu-guest-agent -y

systemctl restart docker && systemctl enable docker
systemctl  restart kubelet && systemctl enable kubelet
systemctl enable qemu-guest-agent && systemctl start qemu-guest-agent


kubeadm config images pull
kubeadm init --apiserver-advertise-address 10.10.10.130 --pod-network-cidr=10.244.0.0/16


mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config


#export kubever=$(kubectl version | base64 | tr -d '\n')
#kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"

curl https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml | sed 's/vxlan/host-gw/g' | sed 's/kube-subnet-mgr\"/&\, \"-iface\"\, \"eth1\"/' > flannel.yml
kubectl apply -f flannel.yml
