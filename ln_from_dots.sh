#!/bin/bash
##
# Quick and dirty script to symlink things to my dotfiles
# NOTE: Needs to be used from the directory the symlink will end up in

set -e

if [ -a $1 ]; then
  mv --no-clobber $1 $1.old || exit 1
  echo Moved $1 to $1.old
fi

ln --symbolic ~/.dotfiles/$1 $1

echo Symlink from ~/.dotfiles/$1 to $1 created

echo Differences:

diff $1.old $1
