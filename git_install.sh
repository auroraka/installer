#!/bin/bash

git clone https://github.com/git/git
cd git
make configure
./configure --prefix=$HOME/App/git
make all -j 32
make install
rm -rf git
