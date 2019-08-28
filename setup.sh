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
DIR="~/.config/linuxconfig/"

say "Setting default make configuration"
touch ~/.profile
grep -qF -- "export MAKEFLAGS=" ~/.profile || echo "export MAKEFLAGS='-j$(nproc --all)'" >> ~/.profile
source ~/.profile
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
if [ -e "/usr/bin/code" ] ; then
  echo "VSCode already installed"
else
  wget -O /tmp/vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
  sudo apt install -y /tmp/vscode.deb
  echo "Done"
fi

say "Installing NordVPN"
if [ -e "/usr/bin/nordvpn" ] ; then
  echo "NordVPN already installed"
else
  wget -O /tmp/nordvpn.deb "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb"
  sudo apt install -y /tmp/nordvpn.deb
  sudo apt install -y nordvpn
  echo "Done"
fi

say "Installing Keybase"
if [ -e "/usr/bin/keybase" ] ; then
  echo "Keybase is already installed"
else
  wget -O /tmp/keybase.deb https://prerelease.keybase.io/keybase_amd64.deb
  sudo apt install -y /tmp/keybase.deb
  echo "Done"
fi

say "Installing Rust"
if [ -e "/usr/local/bin/rustup" ]  ; then
  echo "Rust already installed"
else
  sudo wget -O /usr/local/bin/rustup https://sh.rustup.rs
  sudo chmod 0755 /usr/local/bin/rustup
  rustup -y
  echo "Done"
fi

say "Setting up vim"
if [ -d "$HOME/.vim/" ]; then
  echo "Vim already installed"
else
  git clone https://github.com/seandheath/vim.git ~/.vim
  cd ~/.vim
  /bin/bash setup.sh
  cd $DIR
  echo "Done"
fi

say "Setting up bash"
if [ -d "$HOME/.bash/" ]; then
  echo "Bash already set up"
else
  git clone https://github.com/seandheath/bash.git ~/.bash
  cd ~/.bash
  /bin/bash setup.sh
  cd $DIR
  echo "Done"
fi

say "Setting up PEDA"
if [ -d "/opt/peda/" ]; then
  echo "PEDA already set up"
else
  sudo git clone https://github.com/longld/peda.git /opt/peda
  echo "source /opt/peda/peda.py" >> ~/.gdbinit
  echo "Done"
fi

say "Fixing touchpad"
if [ -e "/lib/systemd/system-sleep/touchpad" ]; then
  echo "Touchpad already fixed"
else
  sudo cp $DIR/files/touchpad /lib/systemd/system-sleep/touchpad
  sudo chmod 0755 /lib/systemd/system-sleep/touchpad
  echo "Done"
fi

say "Disabling system beep"
if [ -e "~/.xprofile" ]; then
  grep -qxF 'xset -b' ~/.xprofile || echo 'xset -b' >> ~/.xprofile
else 
  touch ~/.xprofile
  echo 'xset -b' >> ~/.xprofile
fi
echo "Done"

say "Cleaning up directories"
targets=(Music Pictures Public Templates Videos)
for target in $targets; do 
  if [ -d "~/$target" ]; then
    rm ~/$target
  fi
done
echo "Done"
