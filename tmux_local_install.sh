#!/bin/bash

# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $HOME/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

TMUX_VERSION=2.9a
LIBEVENT_VERSION=2.1.11
BUILD_DIR=/tmp/tmux_build-$USER
BIN_DIR=$HOME/bin

# create our directories
mkdir -p $BUILD_DIR
cd $BUILD_DIR

############
# libevent #
############
wget https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VERSION}-stable/libevent-${LIBEVENT_VERSION}-stable.tar.gz
tar xvzf libevent-${LIBEVENT_VERSION}-stable.tar.gz
cd libevent-${LIBEVENT_VERSION}-stable
./configure --prefix=$BUILD_DIR --disable-shared
make
make install
cd ..

############
#   tmux   #
############
wget -O tmux-${TMUX_VERSION}.tar.gz https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}
./configure CFLAGS="-I$BUILD_DIR/include" LDFLAGS="-L$BUILD_DIR/lib -L$BUILD_DIR/include"
CPPFLAGS="-I$BUILD_DIR/include" LDFLAGS="-static -L$BUILD_DIR/include -L$BUILD_DIR/lib" make
cp tmux $BIN_DIR
cd ..

# cleanup
rm -rf $BUILD_DIR

echo "tmux ${TMUX_VERSION} is now available."
