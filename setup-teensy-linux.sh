#!/bin/bash

set -eux

# This bootstraps the udev rules for the teensy GUI on Linux.
# It is primarily adapted from this answer:
# http://bit.ly/2Cs9xwa

echo "Downloading udev rules for teensy ... "
sudo rm -f /tmp/49-teensy.rules /etc/udev/rules.d/49-teensy.rules /lib/udev/rules.d/49-teensy.rules
wget -O /tmp/49-teensy.rules https://www.pjrc.com/teensy/49-teensy.rules

echo "Installing udev rules for teensy ... "
sudo install -o root -g root -m 0664 /tmp/49-teensy.rules /lib/udev/rules.d/49-teensy.rules

echo "Setting up udev rules"
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Downloading teensy for 64-bit mac ..."
curl -O https://www.pjrc.com/teensy/teensy_linux64.tar.gz
mkdir "$HOME/.teensy"
tar -xvzf teensy_linux64.tar.gz

echo "Succesfully installed Teensy into $HOME/.teensy"

shell_name=$(ps -p "$$" -o comm -h)
case $shell_name in
  "bash" | "zsh")
    echo "Looks like you're using $shell_name."
    echo "PATH=\"\$PATH:\$HOME/.teensy\"" >> "$HOME/.${shell_name}rc"
    ;;
  *)
    echo "Please add this directory to your PATH."
    ;;
esac

