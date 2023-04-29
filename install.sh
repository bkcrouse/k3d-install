#!/bin/bash
yum update -y
sed -i 's/secure_path.*/&:\/usr\/local\/bin/' /etc/sudoers
yum install -y yum-utils 
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y git docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
wget -q -O - https://github.com/k3d-io/k3d/releases/download/v5.4.1/k3d-linux-amd64 > /usr/local/bin/k3d && chmod +x /usr/local/bin/k3d && sudo k3d --version
wget -q -O - https://dl.k8s.io/release/v1.23.5/bin/linux/amd64/kubectl > /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl && ln -s /usr/local/bin/kubectl /usr/local/bin/k
wget -q -O - https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.4/kustomize_v4.5.4_linux_amd64.tar.gz | tar xvfz - && mv kustomize /usr/local/bin && sudo kustomize version
wget -q -O - https://get.helm.sh/helm-v3.8.1-linux-amd64.tar.gz | tar xzf - && mv linux-amd64/helm /usr/local/bin/helm && sudo helm version
echo 'vm.max_map_count=524288' >> /etc/sysctl.d/bigbang.conf
echo 'fs.file-max=131072' >> /etc/sysctl.d/bigbang.conf
ulimit -n 131072
ulimit -u 8192
sysctl --load --system
modprobe xt_REDIRECT
modprobe xt_owner
modprobe xt_statistic
printf "xt_REDIRECT\nxt_owner\nxt_statistic\n" >> /etc/modules-load.d/bigbang_modules.conf
swapoff -a
sed -i '/.*swap/s//#&/' /etc/fstab
firewall-cmd --add-service=http --add-service=https --perm
firewall-cmd --add-port=6443/tcp --perm
firewall-cmd --reload
mkdir $HOME/.k3d-container-image-cache
systemctl enable docker --now
reboot
