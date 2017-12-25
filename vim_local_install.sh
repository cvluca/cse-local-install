#!/bin/bash

# Script for installing vim on systems where you don't have root access.
# vim will be installed in $HOME/.local/usr/local/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

VIM_VERSION=8.0

# create our directories
mkdir -p $HOME/.local/usr/local $HOME/vim_tmp
cd $HOME/vim_tmp

# download source files for vim
wget ftp://ftp.vim.org/ftp/pub/vim/unix/vim-${VIM_VERSION}.tar.bz2

# extract files, configure, and compile
bunzip2 vim-${VIM_VERSION}.tar.bz2
tar xvf vim-${VIM_VERSION}.tar
rm vim-${VIM_VERSION}.tar
cd vim*/
./configure --with-features=huge --enable-pythoninterp --enable-perlinterp --enable-gui=gtk2 --enable-cscope --enable-luainterp --with-lua-prefix=$HOME/.local/usr/local --enable-multibyte --enable-sniff --enable-fontset --prefix=$HOME/.local/usr/local
make
make install

# cleanup
rm -rf $HOME/vim_tmp

#copy to ~/bin
rm $HOME/bin/vim
cp $HOME/.local/usr/local/bin/vim $HOME/bin

cd $HOME
echo "vim ${VIM_VERSION} is now available."