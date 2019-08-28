#!/bin/bash

#setenforce 0
#sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux


#firewall-cmd --permanent --add-port=10250/tcp
#firewall-cmd --permanent --add-port=10255/tcp
#firewall-cmd --permanent --add-port=30000-32767/tcp
#firewall-cmd --permanent --add-port=6783/tcp
#firewall-cmd  --reload
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



# kubeadm join 10.10.10.130:6443 ...
kubeadm join 10.10.10.130:6443 --token nwr3g3.s28n294pgexznktm --discovery-token-ca-cert-hash sha256:222f208155a3f754608344a79ac29efddb09b58d36f27ce9698aa6b2742f52ca --ignore-preflight-errors=all
