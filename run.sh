#!/bin/bash

PKG="dconf-cli seclists gobuster tor"

CONF_DIR="$HOME/.config/linuxconfig"
if ! cd $CONF_DIR ; then
	echo "Config directory not located in $HOME/.config/linuxconfig"
	exit 1
fi

# Install pacman packages
sudo apt update
sudo apt install -y $PKG

# Install pip packages
sudo pip install $PIP_PKG

# Install gtile
if [ ! -d "$HOME/.local/share/gnome-shell/extensions/gTile@vibou" ]; then
	git clone https://github.com/gTile/gTile.git $HOME/.local/share/gnome-shell/extensions/gTile@vibou
fi

# Set up dconf bindings
cd $CONF_DIR
dconf load /org/gnome/desktop/interface/ < files/org-gnome-desktop-interface.dconf
dconf load /org/gnome/desktop/wm/keybindings/ < files/org-gnome-desktop-wm-keybindings.dconf
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < files/org-gnome-settings-daemon-plugins-media-keys.dconf
dconf load /org/gnome/shell/extensions/gtile/ < files/org-gnome-shell-extensions-gtile.dconf
