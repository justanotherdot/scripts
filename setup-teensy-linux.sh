#!/bin/bash

set -eu

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
example_cmd="\"PATH=\"\$PATH:\$HOME/.teensy\"\" >> \"\$HOME/.\${SHELL}rc\""
case $shell_name in
  "bash" | "zsh")
    echo "Looks like you're using $shell_name."
    echo "I'll add this to the path in your runtime config."
    echo "PATH=\"\$PATH:\$HOME/.teensy\"" >> "$HOME/.${shell_name}rc"

    echo "If this isn't right, simply run the following line in your shell"
    echo "$example_cmd"
    ;;
  *)
    echo "Please add this directory to your PATH to finalise the setup."
    echo "$example_cmd"
    ;;
esac

