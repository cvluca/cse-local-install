#!/bin/bash

# Script for installing neovim on systems where you don't have root access.
# vim will be installed in $HOME/.local/usr/local/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

NVIM_VERSION=0.4.2
BUILD_DIR=/tmp/nvim_build-$USER
DIST_DIR=$HOME/.local/usr/local
BIN_DIR=$HOME/bin


# create our directories
mkdir -p $BUILD_DIR
cd $BUILD_DIR

# download source files for vim
wget https://github.com/neovim/neovim/archive/v${NVIM_VERSION}.tar.gz

# extract files, configure, and compile
tar zxvf v${NVIM_VERSION}.tar.gz
rm v${NVIM_VERSION}.tar.gz
cd neovim-${NVIM_VERSION}
make CMAKE_INSTALL_PREFIX=$DIST_DIR
make install

# cleanup
rm -rf $BUILD_DIR

# link to ~/bin
ln -s $DIST_DIR/bin/nvim $BIN_DIR/nvim

echo "neovim ${NVIM_VERSION} is now available."
