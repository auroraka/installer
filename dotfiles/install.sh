#!/bin/bash

set -xe

if [[ $(lsb_release -is) != "Ubuntu" ]];then
  echo "only support ubuntu right now"
  exit 1
fi

## [BEGIN]func tools
command_not_exists () {
  !(type "$1" &> /dev/null);
}
command_exists () {
  type "$1" &> /dev/null;
}

# install from system package manager
require() { 
  if command_not_exists $1;then
    echo "sudo apt install $1"
    sudo apt install $1
  fi  
}

# install from auroraka/installer
install() {
  ~/.ytl/lib/installer/$1/ubuntu_install.sh
}

## [END] func tools

cd ~
## [clone git repo]
require git
if [[ -f ~/.bashrc ]];then mv ~/.bashrc ~/.bashrc.bak;fi
if [[ -f ~/.bash_profile ]];then mv ~/.bash_profile ~/.bash_profile.bak;fi
git init
git remote add origin git@github.com:auroraka/dotfiles.git
git fetch --all
git checkout origin/master -- .gitignore
git reset --hard origin/master
chmod 400 ~/.ssh/config

# [install oh-my-zsh]
require zsh
require wget
install oh-my-zsh
git checkout origin/master -- .zshrc
ln -s -t ~/.oh-my-zsh/themes/ ~/.ytl/etc/oh-my-zsh/auroraka.zsh-theme
cp ~/.ytl/etc/oh-my-zsh/plugins.tar ~/.oh-my-zsh/custom/
cd ~/.oh-my-zsh/custom/ && tar xvzf plugins.tar && cd ~

# [install vim plugin]
require vim
cd ~/.vim && tar xvf ~/.vim/bundle.tar && cd ~

# [install pyenv & pyenv-virtualenv]
install pyenv

# [install trash]
require trash-cli

exec zsh
