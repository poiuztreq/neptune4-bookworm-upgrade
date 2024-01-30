#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo) to execute the script."
  exit
fi

echo "Updating Buster repositories.."
apt update && apt upgrade -y 

echo "Patching Buster repositories to Bookworm and updating"
sed -i '/^#deb-src/d' /etc/apt/sources.list
sed -i '/^#deb http:\/\/security.debian.org\/ buster\/updates main contrib non-free/d' /etc/apt/sources.list
sed -i 's/^deb/#deb/' /etc/apt/sources.list.d/armbian.list
sed -i 's/bullseye/bookworm/' /etc/apt/sources.list
echo "deb http://security.debian.org/ bookworm-security main contrib non-free" | sudo tee -a /etc/apt/sources.list
apt update

echo "Upgrading already installed packages first"
apt upgrade --without-new-pkgs -y

clear

echo "Installing additional Bookworm packages // performing apt full-upgrade"
apt full-upgrade -y

clear

echo "Enabling Armbian repo and cleaning up"
sed -i 's/^#deb/deb/' /etc/apt/sources.list.d/armbian.list
apt autoremove

echo -e "Rebooting system.\nYou have to run 'apt update && apt dist-upgrade' after reboot. Enjoy"
sleep 10
reboot
