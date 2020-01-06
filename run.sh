#!/bin/bash

PKG="progress neovim keepassxc htop go tree qemu virt-manager syncthing cmake openvpn keybase-gui base-devel yay"

AUR_PKG="slack-desktop rslsync"

# Install pacman packages
sudo pacman --needed --noconfirm -S $PKG

# Install AUR packages
yay --needed --noconfirm -S $AUR_PKG

# Install pip packages
sudo pip install openpyn

# Install Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash

# Install gtile
git clone https://github.com/gTile/gTile.git $HOME/.local/share/gnome-shell/extensions/gTile@vibou

# Install vim config
mkdir -p $HOME/.config/nvim
cp $HOME/.config/linuxconfig/files/init.vim $HOME/.config/nvim/
git clone https://seandheath@github.com/seandheath/vim.git $HOME/.vim
cd $HOME/.vim
$HOME/.vim/setup.sh

# Install bash config
git clone https://seandheath@github.com/seandheath/bash.git $HOME/.bash
cd $HOME/.bash
$HOME/.bash/setup.sh

# Set up libvirt image folder
sudo rm -rf /var/lib/libvirt/images
sudo ln -s $HOME/files/vm/images /var/lib/libvirt/images 

# Set up syncthing
rm -rf $HOME/.config/syncthing
ln -s $HOME/files/config/syncthing $HOME/.config/syncthing

# Set up ssh
rm -rf $HOME/.ssh
ln -s $HOME/files/ssh $HOME/.ssh

# Set up rslsync
sudo systemctl enable rslsync
sudo systemctl start rslsync
