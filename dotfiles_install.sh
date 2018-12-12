#!/bin/bash

set -xe
can_sudo=1

# [------- only support ubuntu & centos auto install !!!] ---------

# [prepare for install]
command_not_exists () {
  !(type "$1" &> /dev/null);
}
command_exists () {
  type "$1" &> /dev/null;
}

if [[ -z $can_sudo ]];then
  if command_not_exists wget;then
    echo "wget command not found, exit"
    exit 1
  fi
  if command_not_exists git;then
    echo "git command not found, exit"
    exit 1
  fi
  if command_not_exists zsh;then
    echo "zsh command not found, exit"
    exit 1
  fi
  if command_not_exists vim;then
    echo "vim command not found, exit"
    exit 1
  fi
  if command_not_exists pip3;then
    echo "vim command not found, exit"
    exit 1
  fi
fi

# [check system]
if command_exists apt-get;then
  osget="apt-get"
elif command_exists yum;then
  osget="yum"
else 
  echo "Not Supported Operating System !"
  exit 1
fi

# [clone git repo]
if command_not_exists git;then
  sudo $osget install -y git
fi
cd ~
if [[ -f ~/.bashrc ]];then mv ~/.bashrc ~/.bashrc.bak;fi
if [[ -f ~/.bash_profile ]];then mv ~/.bash_profile ~/.bash_profile.bak;fi
git init
git remote add origin git@github.com:auroraka/dotfiles.git
git fetch --all
git checkout origin/master -- .gitignore
git reset --hard origin/master
chmod 400 ~/.ssh/config

# [install oh-my-zsh]
cd ~
if command_not_exists zsh;then
  sudo $osget install -y zsh
fi
if command_not_exists wget;then
  sudo $osget install -y wget
fi
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
sed -i "s/env zsh//g" install.sh
[[ $(sh install.sh) ]]
rm install.sh
#cp ~/.ytl/oh-my-zsh/auroraka.zsh-theme ~/.oh-my-zsh/themes/
ln -s -t ~/.oh-my-zsh/themes/ ~/.ytl/oh-my-zsh/auroraka.zsh-theme
git checkout origin/master -- .zshrc

# [install zsh plugin]
cd ~
cp ~/.ytl/oh-my-zsh/plugins.tar ~/.oh-my-zsh/custom/
cd ~/.oh-my-zsh/custom/ && tar xvzf plugins.tar && cd ~

# [ install autojump ]
git clone git://github.com/joelthelion/autojump.git && cd autojump && ./install.py && cd .. && rm -rf autojump
cd ~

# [install vim plugin]
cd ~
if command_not_exists vim;then
  sudo $osget install -y vim
fi
cd ~/.vim
tar xvf ~/.vim/bundle.tar

# [install zsh-autosuggestions]
#cd ~
#git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

# [install virtualenv-autodetect]
cd ~
git clone git@github.com:RobertDeRose/virtualenv-autodetect.git ~/.oh-my-zsh/plugins/virtualenv-autodetect

# [install pyenv & pyenv-virtualenv]
cd ~
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command_exists pyenv; then
  eval "$(pyenv init -)"
  export PYTHON_BUILD_MIRROR_URL="http://mirrors.sohu.com/python/3.6.2/"
  if [[ $osget == "apt-get" && $can_sudo ]];then
    sudo apt-get install -y zlib1g-dev
  fi
  #pyenv install -v 3.6.2
  #pyenv global 3.6.2
  eval "$(pyenv init -)"
fi

# [install trash]
if [[ $osget == "apt-get" && $can_sudo ]];then
  sudo apt-get install -y trash-cli
fi

# [history sync]
git clone git@github.com:auroraka/history_sync.git ~/.history_sync

exec zsh
