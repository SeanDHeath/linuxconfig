#!/bin/bash

BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0;0m'

# Formatting output
say()
{
  echo -e "\n${BLUE}##########${NC} $1 ${BLUE}##########${NC}\n"
}

me=$USER
HOME="/home/user"
DIR="/home/user/.config/linuxconfig"

say "Setting default make configuration"
touch $HOME/.profile
grep -qF -- "export MAKEFLAGS=" $HOME/.profile || echo "export MAKEFLAGS='-j$(nproc --all)'" >> $HOME/.profile
source $HOME/.profile
echo "Done"


say "Setting up repositories"
yes "" | sudo add-apt-repository ppa:pbek/qownnotes
echo "Done"

say "Installing packages"
sudo apt update
sudo apt install -y $(cat $DIR/packages)
echo "Done"

say "Fixing libvirt group"
sudo usermod -aG libvirt $me
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
echo "Done"

say "Installing VSCode"
wget -O /tmp/vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
sudo apt install -y /tmp/vscode.deb
echo "Done"

say "Installing NordVPN"
wget -O /tmp/nordvpn.deb "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb"
sudo apt install -y /tmp/nordvpn.deb
sudo apt install -y nordvpn
echo "Done"

say "Installing Keybase"
wget -O /tmp/keybase.deb https://prerelease.keybase.io/keybase_amd64.deb
sudo apt install -y /tmp/keybase.deb
echo "Done"

say "Installing Rust"
wget -O /tmp/rust-init.sh https://sh.rustup.rs 
chmod +x /tmp/rust-init.sh
yes 1 | /tmp/rust-init.sh
echo "Done"

say "Setting up vim"
git clone https://github.com/seandheath/vim.git $HOME/.vim
cd $HOME/.vim
/bin/bash setup.sh
cd $DIR
echo "Done"

say "Setting up bash"
git clone https://github.com/seandheath/bash.git $HOME/.bash
cd $HOME/.bash
/bin/bash setup.sh
cd $DIR
echo "Done"

say "Setting up PEDA"
mkdir --parents $HOME/.gdbmod/
git clone https://github.com/longld/peda.git $HOME/.gdbmod/peda
cd $DIR
sudo cp files/gdb-peda /usr/bin/gdb-peda
sudo chmod +x /usr/bin/gdb-peda
echo "Done"

say "Setting up Pwndbg"
mkdir --parents $HOME/.gdbmod/
git clone https://github.com/pwndbg/pwndbg $HOME/.gdbmod/pwndbg
cd $HOME/.gdbmod/pwndbg/
echo $(pwd)
./setup.sh
cd $DIR
sudo cp files/gdb-pwndbg /usr/bin/gdb-pwndbg
sudo chmod +x /usr/bin/gdb-pwndbg
echo "Done"

say "Setting up GEF"
mkdir --parents $HOME/.gdbmod/gef
wget -O ~/.gdbmod/gef/gdbinit-gef.py -q https://github.com/hugsy/gef/raw/master/gef.py
cd $DIR
sudo cp files/gdb-gef /usr/bin/gdb-gef
sudo chmod +x /usr/bin/gdb-gef
echo "Done"

say "Setting gdbinit"
cd $DIR
cp files/gdbinit $HOME/.gdbinit
echo "Done"

say "Fixing touchpad"
sudo cp $DIR/files/touchpad /lib/systemd/system-sleep/touchpad
sudo chmod 0755 /lib/systemd/system-sleep/touchpad
echo "Done"

say "Disabling system beep"
touch $HOME/.xprofile
grep -qxF 'xset -b' $HOME/.xprofile || echo 'xset -b' >> $HOME/.xprofile
echo "Done"

say "Cleaning up directories"
targets=(Music Pictures Public Templates Videos)
for target in $targets; do 
  if [ -d "$HOME/$target" ]; then
    rm $HOME/$target
  fi
done
echo "Done"
echo ""
