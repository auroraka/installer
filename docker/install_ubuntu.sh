#!/bin/bash

set -xe

ME=$(whoami)
ME_UID=$UID

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

apt update

# install docker
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt update

apt install -y docker-ce

# configure dockerhub mirror
mkdir -p /etc/docker
echo -e "\
{\n\
  \"registry-mirrors\": [\"https://docker.mirrors.ustc.edu.cn/\"]\n
}" > /etc/docker/daemon.json

# add to docker group
if [[ $ME_UID != 0 ]];then
  groupadd -f docker
  usermod -aG docker $ME
fi

# install docker-compose
mkdir -p /usr/local/bin
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

