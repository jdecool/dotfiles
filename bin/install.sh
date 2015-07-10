#!/bin/bash
set -e

# install.sh
# This script installs my basic setup for a debian laptop

# get the user that is not root
USERNAME=$(find /home/* -maxdepth 0 -printf "%f" -type d)
DEBIAN_FRONTEND=noninteractive

check_is_sudo() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit
  fi
}

# sets up apt sources
# assumes you are going to use debian stretch
setup_sources() {
  apt-add-repository ppa:ansible/ansible
  add-apt-repository ppa:webupd8team/java

  sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_15.04/ /' >> /etc/apt/sources.list.d/owncloud-client.list"

  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add
  wget http://download.opensuse.org/repositories/isv:ownCloud:desktop/xUbuntu_15.04/Release.key | apt-key add
}

# installs base packages
# the utter bare minimal shit
base() {
  apt-get update
  apt-get upgrade

  apt-get install -y \
    ansible \
    build-essential \
    curl \
    dconf-editor \
    git \
    htop \
    libsdl-image1.2 \
    libsdl1.2debian \
    mercurial \
    oracle-java8-installer \
    owncloud-client \
    python-pip \
    software-properties-common \
    transmission \
    vim \
    vlc \
    zip \
    zsh \
    --no-install-recommends

  apt-get autoremove
  apt-get autoclean
  apt-get clean

  install_docker
}

# configure ZSH as default shell
setup_zsh() {
  # create subshell
  (
  chsh -s /bin/zsh

  cd /home/$USERNAME/

  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  )
}

# installs docker master
# and adds necessary items to boot params
install_docker() {
  wget -qO- https://get.docker.com/ | sh
  usermod -aG docker $USERNAME

  curl -L https://github.com/docker/compose/releases/download/1.3.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose

  curl -L https://github.com/docker/machine/releases/download/v0.3.0/docker-machine_linux-amd64 > /usr/local/bin/docker-machine
  chmod +x /usr/local/bin/docker-machine
}

get_dotfiles() {
  # create subshell
  (
  cd /home/$USERNAME/

  git clone https://github.com/jdecool/dotfiles.git /home/$USERNAME/dotfiles
  cd /home/$USERNAME/dotfiles

  make

  mkdir -p ~/Workspace
  )
}

usage() {
  echo -e "install.sh\n\tThis script installs my basic setup for an ubuntu 15.04 desktop\n"
  echo "Usage:"
  echo "  sources      - setup sources & install base pkgs"
  echo "  dotfiles     - get dotfiles"
}

main() {
  local cmd=$1

  if [[ -z "$cmd" ]]; then
    usage
    exit 1
  fi

  if [[ $cmd == "sources" ]]; then
    check_is_sudo

    setup_sources
    base

    setup_zsh
  elif [[ $cmd == "dotfiles" ]]; then
    get_dotfiles
  else
    usage
  fi
}

main $@
