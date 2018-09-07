#!/bin/bash

# This bootstraps the udev rules for the teensy GUI on Linux.
# It is primarily adapted from this answer:
# https://forum.pjrc.com/threads/45595-Not-able-to-update-firmware-on-Ergodox-keyboard-on-OpenSuse-42-3-Leap?s=04d77dfde38aabaf45e4f816117bb92b&p=150445&viewfull=1#post150445

( sudo rm -f /tmp/49-teensy.rules /etc/udev/rules.d/49-teensy.rules /lib/udev/rules.d/49-teensy.rules &&
  wget -O /tmp/49-teensy.rules https://www.pjrc.com/teensy/49-teensy.rules &&
  sudo install -o root -g root -m 0664 /tmp/49-teensy.rules /lib/udev/rules.d/49-teensy.rules &&
  sudo udevadm control --reload-rules &&
  sudo udevadm trigger &&
  echo "Success" )

curl -O https://www.pjrc.com/teensy/teensy_linux64.tar.gz
mkdir $HOME/.teensy
tar -xvzf teensy_linux64.tar.gz

echo "Succesfully installed Teensy into your $HOME/.teensy directory"
echo "Please add this directory to your PATH."
