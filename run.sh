#!/bin/bash

PKG="dconf-cli python3-pip seclists gobuster tor"

CONF_DIR="$HOME/.config/linuxconfig"
if ! cd $CONF_DIR ; then
	echo "Config directory not located in $HOME/.config/linuxconfig"
	exit 1
fi

# Install pacman packages
sudo apt update
sudo apt install -y $PKG

# Install pip packages
sudo pip3 install $PIP_PKG

# Set up dconf bindings
cd $CONF_DIR
dconf load /org/gnome/desktop/interface/ < files/org-gnome-desktop-interface.dconf
dconf load /org/gnome/desktop/wm/keybindings/ < files/org-gnome-desktop-wm-keybindings.dconf
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < files/org-gnome-settings-daemon-plugins-media-keys.dconf
dconf load /org/gnome/shell/extensions/gtile/ < files/org-gnome-shell-extensions-gtile.dconf
