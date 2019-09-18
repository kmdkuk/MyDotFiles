#! /bin/sh

sudo -E apt update
sudo -E apt install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -E apt-key add -

sudo -E add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo -E apt update

sudo -E apt install docker-ce docker-ce-cli containerd.io

sudo -E groupadd docker
sudo -E gpasswd -a $USER docker
sudo -E systectl restart docker

sudo -E docker run hello-world

