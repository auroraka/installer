#!/bin/bash -xe
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O _zsh_install.sh

# do not switch to zsh after install
sed -i "s/env zsh//g" _zsh_install.sh
[[ $(sh _zsh_install.sh) ]]
rm _zsh_install.sh

