#!/bin/bash

PKG=$(cat pacman.txt)
AUR_PKG=$(cat aur.txt)
PIP_PKG=$(cat pip.txt)
GIT_TOOLS=$(cat github.txt)

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
        sudo ln -s /usr/bin/nvim /usr/bin/vim
	cd $CONF_DIR
fi

# Install bash config
if [ ! -d "$HOME/.bash" ]; then
	git clone https://seandheath@github.com/seandheath/bash.git $HOME/.bash
	cd $HOME/.bash
	$HOME/.bash/setup.sh
	cd $CONF_DIR
fi

# Set up resiliosync
sudo systemctl --now enable rslsync
sudo usermod -aG rslsync user

# Set up dconf bindings
cd $CONF_DIR
dconf load /org/gnome/desktop/interface/ < files/org-gnome-desktop-interface.dconf
dconf load /org/gnome/desktop/wm/keybindings/ < files/org-gnome-desktop-wm-keybindings.dconf
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < files/org-gnome-settings-daemon-plugins-media-keys.dconf
dconf load /org/gnome/shell/extensions/gtile/ < files/org-gnome-shell-extensions-gtile.dconf

# Set up files folder (if present)
if [ -d "$HOME/files" ]; then
	cd $HOME/files/config
	$HOME/files/config/setup.sh
	cd $CONF_DIR
fi
