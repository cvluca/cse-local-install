#!/bin/bash

# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $HOME/.local/usr/local/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

TMUX_VERSION=2.5

# create our directories
mkdir -p $HOME/.local/usr/local $HOME/tmux_tmp
cd $HOME/tmux_tmp

# download source files for tmux, libevent, and ncurses
wget -O tmux-${TMUX_VERSION}.tar.gz https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
wget https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz

# extract files, configure, and compile

############
# libevent #
############
tar xvzf libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
./configure --prefix=$HOME/.local/usr/local --disable-shared
make
make install
cd ..

############
# ncurses  #
############
tar xvzf ncurses-5.9.tar.gz
cd ncurses-5.9
./configure --prefix=$HOME/.local/usr/local
make
make install
cd ..

############
#   tmux   #
############
tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}
./configure CFLAGS="-I$HOME/.local/usr/local/include -I$HOME/.local/usr/local/include/ncurses" LDFLAGS="-L$HOME/.local/usr/local/lib -L$HOME/.local/usr/local/include/ncurses -L$HOME/.local/usr/local/include"
CPPFLAGS="-I$HOME/.local/usr/local/include -I$HOME/.local/usr/local/include/ncurses" LDFLAGS="-static -L$HOME/.local/usr/local/include -L$HOME/.local/usr/local/include/ncurses -L$HOME/.local/usr/local/lib" make
cp tmux $HOME/.local/usr/local/bin
cd ..

# cleanup
rm -rf $HOME/tmux_tmp

#copy to ~/bin
rm ~/bin/tmux
cp ~/.local/usr/local/bin/tmux ~/bin

echo "tmux ${TMUX_VERSION} is now available."