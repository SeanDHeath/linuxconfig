#!/bin/bash

PKG="ebtables progress neovim keepassxc htop go tree qemu virt-manager syncthing cmake openvpn keybase-gui base-devel yay"
AUR_PKG="slack-desktop rslsync gotop-git"
PIP_PKG="openpyn"

CONF_DIR="$HOME/.config/linuxconfig"
if ! cd $CONF_DIR ; then
	echo "Config directory not located in $HOME/.config/linuxconfig"
	exit 1
fi

# Install pacman packages
sudo pacman --needed --noconfirm -S $PKG

# Install AUR packages
yay --needed --noconfirm -S $AUR_PKG

# Install pip packages
sudo pip install $PIP_PKG

# Install Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash

# Install gtile
if [ ! -d "$HOME/.local/share/gnome-shell/extensions/gTile@vibou" ]; then
	git clone https://github.com/gTile/gTile.git $HOME/.local/share/gnome-shell/extensions/gTile@vibou
fi

# Install vim config
if [ ! -d "$HOME/.vim" ]; then
	mkdir -p $HOME/.config/nvim
	cp $HOME/.config/linuxconfig/files/init.vim $HOME/.config/nvim/
	git clone https://seandheath@github.com/seandheath/vim.git $HOME/.vim
	cd $HOME/.vim
	$HOME/.vim/setup.sh
	cd $CONF_DIR
fi

# Install bash config
if [ ! -d "$HOME/.bash" ]; then
	git clone https://seandheath@github.com/seandheath/bash.git $HOME/.bash
	cd $HOME/.bash
	$HOME/.bash/setup.sh
	cd $CONF_DIR
fi

# Set up files folder (if present)
if [ -d "$HOME/files" ]; then
	cd $HOME/files/config
	$HOME/files/config/setup.sh
	cd $CONF_DIR
fi
